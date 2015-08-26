//
//  WDWebViewBridge.swift
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/26.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

import UIKit
import Foundation

typealias WDWebViewBridgeFinish = (message:AnyObject) ->Void


class WDWebViewBridge: NSObject,UIWebViewDelegate {
    var bridgeWebView:UIWebView!
    var messageArray:NSMutableArray!
    var delegate:WDWebViewBridgeProtocol?
    
    func initWithBridgeWebView(webView:UIWebView){
        self.bridgeWebView = webView
        self.messageArray = NSMutableArray();
        self.bridgeWebView.delegate = self
    }
    
    //给javascript发消息
    func  wdBridgeSend(sendMessage:String,responseBlock:WDWebViewBridgeFinish){
        var message:WDMessage = WDMessage()
        message.initTimeKey()
        message.sendBackBlock = responseBlock
        message.content = sendMessage
        self.messageArray.addObject(message)
        
        var messageDictionary:NSMutableDictionary =  NSMutableDictionary()
        messageDictionary.setObject(message.time_key!, forKey: "time_key")
        messageDictionary.setObject(message.content!, forKey: "sendMessage")
        var jsonData:NSData  = NSJSONSerialization.dataWithJSONObject(messageDictionary as Dictionary, options: NSJSONWritingOptions.PrettyPrinted, error: nil)!
        var json:NSString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)!
        
        var javaScript:NSString = NSString(format: "AppBridge.monitorAppMessage('%@')", json)
        javaScript = javaScript.stringByReplacingOccurrencesOfString("\n", withString: "")
        javaScript = javaScript.stringByReplacingOccurrencesOfString("\r", withString: "")
        javaScript = javaScript.stringByReplacingOccurrencesOfString(" ", withString: "")
        self.bridgeWebView.stringByEvaluatingJavaScriptFromString(javaScript as String)
    }
    
    //用于收到js消息后响应到
    func resposeMessgeToJavaScript(responseMessage:String){
        var message:NSString = NSString(format: "AppBridge.appReceiveFinish('%@')", responseMessage)
        self.bridgeWebView.stringByEvaluatingJavaScriptFromString(message as String)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        var bundlePath:String = NSBundle.mainBundle().pathForResource("WDWebViewBridge", ofType: "js")!
        var javaScript:String = String(contentsOfFile: bundlePath, encoding: NSUTF8StringEncoding, error: nil)!
        self.bridgeWebView.stringByEvaluatingJavaScriptFromString(javaScript)
        if delegate != nil {
            delegate?.wdWebViewDidStartLoad!(webView)
        }
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        if delegate != nil{
            delegate?.wdWebViewDidFinishLoad!(webView)
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var url = request.URL!.absoluteString?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding);
        //接收到js发来的消息
        if url!.hasPrefix("wdbridgesend://"){
            var message = url!.stringByReplacingOccurrencesOfString("wdbridgesend://",
                withString:"");
            if delegate != nil{
                delegate?.wdBridgelistener(self, message: message)
            }
            return false
        }
        
        //app发出去消息的回调
        if url!.hasPrefix("wdbridgeresponse://"){
            //回调过来的信息
            var message = url!.stringByReplacingOccurrencesOfString("wdbridgeresponse://",
                withString: "");
            var backObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(message.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            var currentMessage:WDMessage!
            for tempMessage in self.messageArray{
                if (backObject?.valueForKey("time_key") as! NSString).isEqualToString((tempMessage as! WDMessage).time_key!){
                    currentMessage = tempMessage as! WDMessage
                }
            }
            if currentMessage != nil{
                currentMessage.sendBackBlock!(message: (backObject!.valueForKey("sendMessage"))!)
            }
            return false
        }
        if delegate != nil{
            delegate?.wdWebViewDidFinishLoad!(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
        }
        return true;
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        if delegate != nil{
            delegate?.webView!(webView, didFailLoadWithError: error)
        }
    }
}


@objc protocol WDWebViewBridgeProtocol{
    func wdBridgelistener(bridge:WDWebViewBridge,message:String)
    optional func wdWebViewDidStartLoad(webView:UIWebView)
    optional func wdWebViewDidFinishLoad(webView:UIWebView)
    optional func wdWebViewDidFinishLoad(webView:UIWebView,shouldStartLoadWithRequest request:NSURLRequest,navigationType:UIWebViewNavigationType) ->Bool
    optional func webView(webView: UIWebView, didFailLoadWithError error: NSError)
}

