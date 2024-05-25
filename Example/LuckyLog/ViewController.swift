//
//  ViewController.swift
//  LuckyLog
//
//  Created by 汤俊杰 on 05/25/2024.
//  Copyright (c) 2024 汤俊杰. All rights reserved.
//

import UIKit
import LuckyLog

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        LKLog.list.forEach { target in
            if let console = target as? Log.Console {
                console.level = .error
            }
        }
        
        LKLog.log(msg: "aaa", level: .error)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

