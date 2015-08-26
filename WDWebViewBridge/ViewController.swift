//
//  ViewController.swift
//  WDWebViewBridge
//
//  Created by 何伟东 on 15/8/26.
//  Copyright (c) 2015年 何伟东. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WDWebViewBridgeProtocol{
    
    @IBOutlet weak var webView: UIWebView!
    var bridge:WDWebViewBridge!
    override func viewDidLoad() {
        super.viewDidLoad()
        bridge = WDWebViewBridge()
        bridge.initWithBridgeWebView(webView)
        bridge.delegate = self
        
        var filePath:String = NSBundle.mainBundle().pathForResource("Example", ofType: "html")!
        var htmlString:String = String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil)!
        self.webView.loadHTMLString(htmlString, baseURL: NSURL(string: htmlString))
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //发送消息给js
    @IBAction func sendMessageToJavaScriptAction(sender: UIButton) {
        self.bridge.wdBridgeSend("哈哈哈哈哈哈，给js发消息", responseBlock: { (message) -> Void in
            println("js的反馈:" + (message as! String))
        })
    }
    
    //监听webview js 过来的消息
    func wdBridgelistener(bridge:WDWebViewBridge,message:String){
        //响应给js，非必需
        self.bridge.resposeMessgeToJavaScript(message)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wdWebViewDidStartLoad(webView:UIWebView){
    
    }
    
    func wdWebViewDidFinishLoad(webView:UIWebView){
    
    }
    
    func wdWebViewDidFinishLoad(webView:UIWebView,shouldStartLoadWithRequest request:NSURLRequest,navigationType:UIWebViewNavigationType) ->Bool{
        return true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError){
    
    }

}

