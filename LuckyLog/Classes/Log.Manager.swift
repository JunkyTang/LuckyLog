//
//  Log.Manager.swift
//  Alamofire
//
//  Created by junky on 2024/5/23.
//

import Foundation

public let LKLog = Log.Manager.shared

extension Log {
    
    public class Manager: Target {
        
        public static let shared = Manager()
        
        public var list: [Target] = [Console(level: .debug)]
        
        public var level: Log.Level = .debug
        
        public func log(msg: String, level: Log.Level, file: String = #file, function: String = #function, line: Int = #line) {
            
            if level.rawValue < self.level.rawValue {
                return
            }
            list.forEach{ $0.log(msg: msg, level: level, file: file, function: function, line: line) }
        }
    }
}
