//
//  CJWebView.swift
//  CJMetro
//
//  Created by C.K.Lian on 2024/2/29.
//

import UIKit
import WebKit
import Cartography

class CJScriptMessageHandler: NSObject, WKScriptMessageHandler {
    var scriptHandler: ((Any) -> Void)?
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let scriptHandler = self.scriptHandler {
            scriptHandler(message.body)
        }
    }
    
    deinit {
        debugPrint("\(type(of: self)) deinitialized")
    }
}

typealias WebViewClickBlock = (CGPoint) -> Void
typealias ReloadBlock = (WKWebView) -> Void
typealias StartBlock = (WKWebView,WKNavigation) -> Void
typealias DidFinishBlock = (WKWebView,WKNavigation) -> Void
typealias DidFailBlock = (WKWebView,WKNavigation,Error) -> Bool
class CJWebView: WKWebView, WKNavigationDelegate {
    var point: CGPoint = CGPoint(x:0, y:0)
    var startBlock: StartBlock?
    
    var clickBlock: WebViewClickBlock?
    
    /**
     加载完成回调
    */
    var finishBlock: DidFinishBlock?
    
    var failBlock: DidFailBlock?
    var reloadeBlock: ReloadBlock?
    var showProgress: Bool = true
    
    private var progressView: UIProgressView!
    
    deinit {
        debugPrint("\(type(of: self)) deinitialized")
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        configure()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        self.point = point
        if let clickBlock = clickBlock {
            clickBlock(point)
        }
        return true
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
 
    private func configure() {
        self.navigationDelegate = self
        if #available(iOS 16.4, *) {
            self.isInspectable = true
        } else {
            // Fallback on earlier versions
        }
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.backgroundColor = UIColor.separator_E8
        progressView.tintColor = UIColor.logo_color
        progressView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 4)
        addSubview(progressView)
        progressView.isHidden = true
        constrain(self, progressView) { (view, progressView) in
            progressView.top == view.top
            progressView.left == view.left
            progressView.right == view.right
            progressView.height == 4
        }
        addObserver(self, forKeyPath: #keyPath(estimatedProgress), options: .new, context: nil)
    }
 
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(estimatedProgress), animated: true)
            if estimatedProgress >= 1 {
                progressView.isHidden = true
            } else {
                if(self.showProgress){
                    progressView.isHidden = false
                }
            }
        }
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("开始加载网页")
        if(startBlock != nil){
            startBlock!(webView,navigation)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("网页加载完成")
        if let finishBlock = finishBlock {
            finishBlock(webView,navigation)
        }
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint("加载临时Frame失败: \(error)")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("加载失败: \(error)")
//        CJHUD.cj_showMessage(LocalizedStr("网络异常"))
        if let failBlock = failBlock {
            let custom = failBlock(webView,navigation,error)
            if(!custom){
                self.errorNetWork {[weak self] _ in
                    if let reloadeBlock = self?.reloadeBlock {
                        reloadeBlock(webView)
                        return true
                    }
                    return false
                }
            }
        }else{
            self.errorNetWork {[weak self] _ in
                if let reloadeBlock = self?.reloadeBlock {
                    reloadeBlock(webView)
                    return true
                }
                return false
            }
        }
    }
    
}
