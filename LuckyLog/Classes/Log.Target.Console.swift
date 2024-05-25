//
//  Log.Target.Console.swift
//  Alamofire
//
//  Created by junky on 2024/5/23.
//

import Foundation

extension Log {
    
    public class Console: Target {
        
        public var level: Log.Level = .debug
        
        public init(level: Log.Level = .debug) {
            self.level = level
        }
        
        public func log(msg: String, level: Log.Level, file: String = #file, function: String = #function, line: Int = #line) {
            #if !DEBUG
            return
            #else
            if level.rawValue < self.level.rawValue {
                return
            }
            let log = assembleLog(msg: msg, level: level, file: file, function: function, line: line)
            print(log)
            #endif
        }
        
        
    }
}
