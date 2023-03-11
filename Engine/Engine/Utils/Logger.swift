//
//  Logger.swift
//  Engine
//
//  Created by Guillaume Audinet on 10/03/2023.
//

import Foundation

extension DateFormatter {
    static let hoursWithMillisecondsFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter
    }()
}

class Logger: NSObject {
    // MARK: Public interface
    enum LogCategory: String {
        case none      = "   "
        case info      = "ℹ️ "
        case warning   = "⚠️ "
        case error     = "⛔️ "
        case success   = "✅ "
        case likeABoss = "😎 "
        case test      = "❔ "
        case request   = "➡️ "
        case response  = "⬅️ "
        case start     = "🚀 "
        case end       = "🏁 "
        case package   = "📦 "
    }
    
    /// Used to print message. Use shortend instead of this method
    ///
    /// - Parameters:
    ///   - message: message to print
    ///   - category: category of the message
    static func log(message: String, category: LogCategory, date: Date?) {
        let fullMessage = category.rawValue
            .appending(getString(from: message, date: date))
            .replacingOccurrences(of: "\n", with: "\n   ")
        
        print(fullMessage)
    }
        
    private static func getString(from string: String, date: Date?) -> String {
        let dateFormatter = DateFormatter.hoursWithMillisecondsFormatter
        return dateFormatter.string(from: date ?? Date()) + " " + string
    }
}

/// Shorthand
func LOG(_ message: String, _ category: Logger.LogCategory = .none, date: Date? = nil) {
    Logger.log(message: message, category: category, date: date)
}
func SLOG(_ message: String, date: Date? = nil) {
    Logger.log(message: message, category: .success, date: date)
}
func ILOG(_ message: String, date: Date? = nil) {
    Logger.log(message: message, category: .info, date: date)
}
func WLOG(_ message: String, date: Date? = nil) {
    Logger.log(message: message, category: .warning, date: date)
}
func ELOG(_ message: String, date: Date? = nil) {
    Logger.log(message: message, category: .error, date: date)
}
func StartLOG(_ message: String, date: Date? = nil) {
    Logger.log(message: message, category: .start, date: date)
}
func RequestLOG(_ message: String, date: Date? = nil) {
    Logger.log(message: message, category: .request, date: date)
}
func ResponseLOG(_ message: String, date: Date? = nil) {
    Logger.log(message: message, category: .response, date: date)
}
