//
//  FileDataStore.swift
//  Engine
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import Foundation
import UIKit

class FileDataStore {
    @discardableResult
    func persist<T: Encodable>(codable: T?, filename: String, in directory: String) -> String? {
        guard let codable = codable else {
            // Persisting null at a path is equivalent to deleting file
            deleteFileIfExists(in: directory, filename: filename)
            return nil
        }
        
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(codable)
            do {
                return try persist(data: encoded, in: directory, filename: filename)
            } catch let error {
                ELOG("[FileDatastore] Error persisting \(codable) to \(filename)) \(error)")
                return nil
            }
        } catch let error {
            ELOG("[FileDatastore] Unable to encode \(codable) -> \(error)")
            return nil
        }
    }
    
    func decodableOrThrowing<T: Decodable>(from filename: String, in directory: String) throws -> T {
        do {
            let data = try self.data(
                from: directory,
                filename: filename
            )
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error {
            LOG("[FileDatastore] Error reading data from \(filename) -> \(error)")
            if error is DecodingError {
                LOG("[FileDatastore] Data from \(filename) corrupted, deleting file")
                deleteFileIfExists(at: filePath(in: directory, filename: filename))
            }
            throw error
        }
    }
    
    func decodable<T: Decodable>(from filename: String, in directory: String) -> T? {
        do {
            return try decodableOrThrowing(from: filename, in: directory)
        } catch _ {
            return nil
        }
    }
    
    func deleteFileIfExists(at path: String) {
        guard fileExists(at: path) else { return }
        do {
            try deleteFile(at: path)
            LOG("[FileDataStore] Deleted file \(path)")
        } catch let error {
            ELOG("[FileDataStore] Error deleting file at \(path) : \(error)")
        }
    }
    
    func deleteFileIfExists(in directory: String, filename: String) {
        deleteFileIfExists(at: filePath(in: directory, filename: filename))
    }
    
    func rootDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        return (paths[0] as NSString) as String
    }
    
    // MARK: - Private
    @discardableResult
    internal func persist(data: Data, in directory: String, filename: String) throws -> String {
        try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        let path = filePath(in: directory, filename: filename)
        try persist(data: data, at: URL(fileURLWithPath: path))
        LOG("[FileDataStore] Data persisted to \(path)")
        return path
    }
    
    internal func data(from directory: String, filename: String) throws -> Data {
        let url = URL(fileURLWithPath: filePath(in: directory, filename: filename))
        return try data(at: url)
    }
    
    func persist(data: Data, at fileUrl: URL) throws {
        try data.write(to: fileUrl, options: [.atomic])
    }
    
    func data(at fileUrl: URL) throws -> Data {
        return try Data(contentsOf: fileUrl)
    }
    
    func filePath(in directory: String, filename: String) -> String {
        return (directory as NSString).appendingPathComponent(filename)
    }
    
    func hierarchyFromRootDirectory(directories: String...) -> String {
        var documentsDirectory = self.rootDirectory() as NSString
        directories.forEach { documentsDirectory = documentsDirectory.appendingPathComponent($0) as NSString }
        return documentsDirectory as String
    }
    
    func fileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    internal func fileExists(in directory: String, filename: String) -> Bool {
        return fileExists(at: filePath(in: directory, filename: filename))
    }
    
    private func deleteFile(at path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    private func deleteFile(from directory: String, filename: String) throws {
        try deleteFile(at: filePath(in: directory, filename: filename))
    }
}
