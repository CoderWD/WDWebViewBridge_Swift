# WDWebViewBridge_Swift
1.javascript

//给app发送消息，及回调方法
	function sendMessageToApp(message){
		AppBridge.sendMessageToApp(message,function calback(backMessage){
			alert(backMessage,"操作提示：");
		});
	}

	//监听接收app发过来的消息
	AppBridge.receiveAppMessage = function receiveAppMessage(message){
		alert(message,"操作提示：");
	}
	
2.swift
  
  //初始化
  bridge = WDWebViewBridge()
  bridge.initWithBridgeWebView(webView)
  bridge.delegate = self
        
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
    
