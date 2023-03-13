//
//  ExpirableFileDataStore.swift
//  Engine
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import Foundation
import UIKit

public class ExpirableFileDataStore {

    static let kExpirationTimeForPathsFilename = "cacheValidity"

    let expirableTableQueue = DispatchQueue(label: "com.gaudinet.MySuperWeather.expirableFileDataStore")

    let dataStore: FileDataStore
    var updatedTimeForPaths: [String: Date] {
        didSet {
            dataStore.persist(
                codable: updatedTimeForPaths,
                filename: ExpirableFileDataStore.kExpirationTimeForPathsFilename,
                in: dataStore.rootDirectory()
            )
        }
    }

    init(dataStore: FileDataStore) {
        self.dataStore = dataStore
        updatedTimeForPaths = dataStore.decodable(
            from: ExpirableFileDataStore.kExpirationTimeForPathsFilename,
            in: dataStore.rootDirectory()
        ) ?? [String: Date]()
    }

    func persist<T: Encodable>(codable: T?, filename: String, in directory: String, resetCacheExpiration: Bool = true) {
        let key = cacheKey(for: filename, in: directory)
        if dataStore.persist(codable: codable, filename: filename, in: directory) != nil {
            if resetCacheExpiration {
                updateCache(updatedAt: Date(), for: key)
            }
        }
    }

    func decodable<T: Decodable>(from filename: String, in directory: String, maxValidity: TimeInterval? = nil) -> T? {
        guard isCacheValid(from: filename, in: directory, maxValidity: maxValidity) else {
            return nil
        }
        do {
            return try dataStore.decodableOrThrowing(from: filename, in: directory)
        } catch let error {
            if error is DecodingError {
                LOG("[ExpirableFileDataStore] Data from \(filename) corrupted, deleting cache")
                invalidateCache(from: filename, in: directory)
            }
            return nil
        }
    }

    func isCacheValid(from filename: String, in directory: String, maxValidity: TimeInterval? = nil) -> Bool {
        let key = cacheKey(for: filename, in: directory)
        guard let lastCacheDate = updatedAt(for: key) else {
            return false
        }
        if  let maxValidity = maxValidity,
            lastCacheDate.addingTimeInterval(maxValidity) < Date() {
            return false
        }
        return true
    }

    func deleteFileIfExists(in directory: String, filename: String) {
        dataStore.deleteFileIfExists(in: directory, filename: filename)
        invalidateCache(from: filename, in: directory)
    }
    private func cacheKey(for filename: String, in directory: String) -> String {
        return filename // FIXME: Return filename relative path to rootDirectory
    }
}

// MARK: - Cache sync access
extension ExpirableFileDataStore {

    func updatedAt(for key: String) -> Date? {
        return expirableTableQueue.sync {
            updatedTimeForPaths[key]
        }
    }

    func updateCache(updatedAt: Date, for key: String) {
        expirableTableQueue.sync { updatedTimeForPaths[key] = updatedAt }
    }

    func invalidateCache(from filename: String, in directory: String) {
        let key = cacheKey(for: filename, in: directory)
        _ = expirableTableQueue.sync { updatedTimeForPaths.removeValue(forKey: key) }
    }
}
