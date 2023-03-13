//
//  AsyncCacheHandling.swift
//  Engine
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import Foundation

protocol AsyncCacheHandling: AnyObject {
    var fileDataStore: FileDataStore { get }
    func persistAsync<T: Encodable>(object: T?,
                                    filename: String,
                                    directory: String,
                                    onDone: (() -> Void)?)
    func readFromCacheAsync<T: Decodable>(filename: String,
                                          directory: String,
                                          onDone: ((T?) -> Void)?)
}

protocol AsyncExpirableCacheHandling: AnyObject {
    var expirableDataStore: ExpirableFileDataStore { get }
    func persistAsync<T: Encodable>(object: T?,
                                    filename: String,
                                    directory: String,
                                    resetCacheExpiration: Bool,
                                    onDone: (() -> Void)?)
    func readFromCacheAsync<T: Decodable>(filename: String,
                                          directory: String,
                                          maxValidity: TimeInterval?,
                                          onDone: ((T?) -> Void)?)
}

extension AsyncCacheHandling {
    func persistAsync<T: Encodable>(
        object: T?,
        filename: String,
        directory: String,
        onDone: (() -> Void)? = nil
    ) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.fileDataStore.persist(codable: object, filename: filename, in: directory)
            DispatchQueue.main.async {
                onDone?()
            }
        }
    }
    func readFromCacheAsync<T: Decodable>(
        filename: String,
        directory: String,
        onDone: ((T?) -> Void)?
    ) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let object: T = self?.fileDataStore.decodable(from: filename, in: directory) {
                DispatchQueue.main.async {
                    onDone?(object)
                }
            } else {
                DispatchQueue.main.async {
                    onDone?(nil)
                }
            }
        }
    }
}

extension AsyncExpirableCacheHandling {
    func persistAsync<T: Encodable>(
        object: T?,
        filename: String,
        directory: String,
        resetCacheExpiration: Bool = true,
        onDone: (() -> Void)? = nil
    ) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.expirableDataStore.persist(codable: object, filename: filename, in: directory, resetCacheExpiration: resetCacheExpiration)
            DispatchQueue.main.async {
                onDone?()
            }
        }
    }
    func readFromCacheAsync<T: Decodable>(
        filename: String,
        directory: String,
        maxValidity: TimeInterval?,
        onDone: ((T?) -> Void)?
    ) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            if let object: T = self?.expirableDataStore.decodable(from: filename, in: directory, maxValidity: maxValidity) {
                DispatchQueue.main.async {
                    onDone?(object)
                }
            } else {
                DispatchQueue.main.async {
                    onDone?(nil)
                }
            }
        }
    }
}
