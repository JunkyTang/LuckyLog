//
//  Log.Target.swift
//  Alamofire
//
//  Created by junky on 2024/5/23.
//

import Foundation


extension Log {
    
    public enum Level: Int {
        case debug = 0
        case info = 1
        case warning = 2
        case error = 3
        
        public var desc: String {
            switch self {
            case .debug:
                return "[DEBUG]"
            case .info:
                return "[INFO]"
            case .warning:
                return "[WARNING]"
            case .error:
                return "[ERROR]"
            }
        }
    }
    
    public protocol Target {
        
        var level: Level { get }
        
        func log(msg: String, level: Log.Level, file: String, function: String, line: Int)
    }
}


extension Log.Target {
    
    public func assembleLog(msg: String, level: Log.Level, file: String, function: String, line: Int) -> String {
        let path = URL(string: file)
        let fileName = path?.lastPathComponent ?? "Unknown"
        return "\(level.desc)\(fileName)-\(function)[\(line)]: \(msg)"
    }
}
