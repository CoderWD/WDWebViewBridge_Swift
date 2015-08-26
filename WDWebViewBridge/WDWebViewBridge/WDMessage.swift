//
//  WDMessage.swift
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/26.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

import UIKit
import Foundation

class WDMessage: NSObject {
    var content:String?
    var time_key:String?
    var sendBackBlock:WDWebViewBridgeFinish?
    
    func initTimeKey() {
       self.time_key = NSString(format:"%f", NSDate().timeIntervalSince1970) as String
    }
}
