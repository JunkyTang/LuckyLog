//
//  Log.Target.File.swift
//  Alamofire
//
//  Created by junky on 2024/5/23.
//

import UIKit
import LuckyException

extension Log {
    
    public class LogFile {
        
        static func getSanboxDirectoryPath() throws -> URL {
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                throw Exception(msg: "Get document Directory url failure")
            }
            url.appendPathComponent("log", isDirectory: true)
            url.appendPathComponent(Date().string(format: "yyyy-MM-dd"), isDirectory: true)
            return url
        }
        
        static func getSanboxFilePath(name: String = Date().string(format: "HH:mm:ss:SSS")) throws -> URL {
            var url = try getSanboxDirectoryPath()
            url.appendPathComponent(name + ".txt", isDirectory: false)
            return url
        }
        
        static func save(file: LogFile) throws {
            
            let directory = try getSanboxDirectoryPath()
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            let url = try getSanboxFilePath()
            let content = file.content.joined(separator: "\n")
            try content.write(to: url, atomically: true, encoding: .utf8)
        }
        
        var id: String = UUID().uuidString
        var content: [String] = []
        
    }
    
    public class File: Target {
    
        public var level: Log.Level = .debug
        var list: [LogFile] = []
        var countPerFile: Int = 1000
        
        public func log(msg: String, level: Log.Level, file: String = #file, function: String = #function, line: Int = #line) {
            
            let log = assembleLog(msg: msg, level: level, file: file, function: function, line: line)
            let file: LogFile = list.last ?? LogFile()
            file.content.append(log)
            if list.contains(where: { $0.id == file.id}) == false {
                list.append(file)
            }
            check(file)
        }
        
        func check(_ file: LogFile) {
            
            if file.content.count < countPerFile {
                return
            }
            
            list.removeAll(where: { $0.id == file.id })
            do {
                try LogFile.save(file: file)
            } catch {
                print(error)
            }
        }
        
        public init(level: Log.Level = .debug, list: [LogFile] = [], countPerFile: Int = 1000) {
            self.level = level
            self.list = list
            self.countPerFile = countPerFile
            
            // 结束进程是保存log
            NotificationCenter.default.addObserver(self, selector: #selector(appWillBeKill), name: Notification.Name.UIApplicationWillTerminate, object: nil)
        }
                
        @objc func appWillBeKill() {
            
            let file_list: [File] = Log.Manager.shared.list.compactMap { target in
                guard let file = target as? File else { return nil }
                return file
            }
            
            file_list.forEach { file in
                guard let last = file.list.last else { return }
                try? LogFile.save(file: last)
            }
        }
        
    }
    
}


extension Date {
    
    func string(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
