//
//  NetworkClient.swift
//  Engine
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import Foundation

class NetworkClient {
    enum ParameterEncoding {
        case JSON
        case URL
    }
    
    var baseURL: URL
    
    init(configuration: EngineConfiguration) {
        self.baseURL = configuration.network.baseUrl
    }
    
    private func url(for endpoint: Endpoint) -> URL? {
        if #available(iOS 16.0, *) {
            return baseURL.appending(path: endpoint.path)
        } else {
            let stringBaseUrl = baseURL.absoluteString
            let finalUrl = "\(stringBaseUrl)\(endpoint.path)"
            return URL(string: finalUrl)
        }
    }
    
    // MARK: - HTTP Methods
    
    /// onDone is called on the main thread
    @discardableResult
    public func call(endpoint: Endpoint,
                     dict: [String: Any?]? = nil,
                     parameterEncoding: ParameterEncoding = .JSON,
                     authenticatedHeaders: Bool = false,
                     additionnalHeaders: [String: String] = [:],
                     onDone: @escaping (Result<(Data, Int), Error>) -> Void) -> URLSessionDataTask? {
        guard let url = url(for: endpoint) else { return nil }
        return call(url: url,
                    verb: endpoint.verb,
                    dict: dict,
                    parameterEncoding: parameterEncoding,
                    authenticatedHeaders: authenticatedHeaders,
                    additionnalHeaders: additionnalHeaders,
                    onDone: onDone)
    }
    
    private func call(url: URL,
                      verb: HTTPVerb,
                      dict: [String: Any?]?,
                      parameterEncoding: ParameterEncoding = .JSON,
                      authenticatedHeaders: Bool,
                      additionnalHeaders: [String: String],
                      onDone: @escaping (Result<(Data, Int), Error>) -> Void) -> URLSessionDataTask? {
        var data: Data?
        var encodedURL: URL = url
        if parameterEncoding == .JSON, let dict = dict {
            data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        } else if parameterEncoding == .URL, let dict = dict {
            encodedURL = NetworkClient.url(with: encodedURL, urlParams: dict)
        }
                
        return call(url: encodedURL,
                    verb: verb,
                    data: data,
                    authenticatedHeaders: authenticatedHeaders,
                    additionnalHeaders: additionnalHeaders,
                    onDone: onDone)
    }
    
    private func call(url: URL,
                      verb: HTTPVerb,
                      data: Data?,
                      authenticatedHeaders: Bool,
                      additionnalHeaders: [String: String],
                      onDone: @escaping (Result<(Data, Int), Error>) -> Void) -> URLSessionDataTask? {
        var request = URLRequest(url: url)
        request.httpMethod = verb.rawValue
        
        var allHeaders: [String: String] = ["content-type": "application/json"]
        
        additionnalHeaders.forEach { (key: String, value: String) in
            allHeaders[key] = value
        }
        
        request.allHTTPHeaderFields = allHeaders
        request.httpBody = data
        request.timeoutInterval = 30
        
        return call(request: request, onDone: onDone)
    }
    
    @discardableResult
    private func call(
        request: URLRequest,
        onDone: @escaping (Result<(Data, Int), Error>) -> Void
    ) -> URLSessionDataTask {
        let beginDate = Date()
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.requestLOG(request, date: beginDate)
            guard let data = data, error == nil, let urlResponse = response as? HTTPURLResponse else {
                guard let error else { return }
                self?.dispatchToMainThread(asyncCallResult: .failure(error), block: onDone)
                self?.errorLOG(error)
                return
            }
            self?.responseLOG(urlResponse, data: data)
            
            guard let self else { return }
            self.dispatchToMainThread(
                asyncCallResult: .success((data, urlResponse.statusCode)),
                block: onDone
            )
        }
        
        task.resume()
        return task
    }
    
    private func requestLOG(_ request: URLRequest, date: Date) {
        RequestLOG(
            """
            [NetworkClient] cURL Request:
            \(request.curlString)
            -->
            """, date: date
        )
    }
    
    private func errorLOG(_ error: Error) {
        ELOG(
            """
            [NetworkClient] Network Error :
            \(error)
            """
        )
    }
    
    private func responseLOG(_ urlResponse: HTTPURLResponse, data: Data) {
        ResponseLOG(
            """
            [NetworkClient]
            Code HTTP : \(urlResponse.statusCode)
            Response JSON \(data.prettyPrintedJSONString ?? String(data: data, encoding: .utf8) ?? "")
            
            """
        )
    }
    
    // MARK: - Thread Helper
    private func dispatchToMainThread(
        asyncCallResult: (Result<(Data, Int), Error>),
        block: @escaping (Result<(Data, Int), Error>) -> Void
    ) {
        DispatchQueue.main.async {
            block(asyncCallResult)
        }
    }
    
    // MARK: - Parsing Helpers
    static func url(with url: URL, urlParams dict: [String: Any?]) -> URL {
        var urlComponents = URLComponents(string: url.absoluteString)
        
        let queryItems = dict.flatMap({ (key, value) -> [URLQueryItem] in
            if let value = value as? String {
                return [ URLQueryItem(name: key, value: value) ]
            } else if let value = value as? Int {
                return [ URLQueryItem(name: key, value: "\(value)") ]
            } else if let value = value as? Double {
                return [ URLQueryItem(name: key, value: "\(value)") ]
            } else if let value = value as? [String] {
                return value.compactMap({ string -> URLQueryItem? in
                    return URLQueryItem(name: "\(key)[]", value: string)
                })
            } else if let value = value as? Bool {
                return [ URLQueryItem(name: key, value: value.description) ]
            }
            
            return []
        })
        
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url ?? url
    }
}
