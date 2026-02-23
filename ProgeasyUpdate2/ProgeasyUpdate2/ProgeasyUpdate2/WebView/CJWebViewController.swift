//
//  CJWebViewController.swift
//  CJMetro
//
//  Created by lele8446 on 2024/4/18.
//

import Foundation
import WebKit
import Cartography
import Alamofire

class CJWebViewController: UIViewController {
    var myTitle: String?
    var url: String?
    var rawData: Bool = false
    
    let webView = CJWebView(frame: .zero)
    
    deinit {
        debugPrint("\(type(of: self)) deinitialized")
    }
    
    init(myTitle: String? = nil, url: String? = nil, rawData: Bool = false) {
        self.myTitle = myTitle
        self.url = url
        self.rawData = rawData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.view_color
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        if(myTitle != nil){
            self.navigationItem.title = LocalizedStr(myTitle!)
        }
        
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.reloadeBlock = {[weak self] web in
            
            self?.loadData()
        }
        view.addSubview(webView)
        constrain(view, webView) { (view, webView) in
            webView.top == view.top + 0
            webView.left == view.left
            webView.right == view.right
            webView.bottom == view.bottom
        }
        
        loadData()
    }
    
    func loadData() {
        if(url == nil ) {
            debugPrint("\(String(describing: myTitle)): url不存在")
            CJHUD.cj_showMessage(LocalizedStr("Data exception"))
        }else{
            if(rawData){
                loadRawData()
            }else{
                if let loadURL = URL(string: url!) {
                    let request = URLRequest(url: loadURL)
                    webView.load(request)
                } else {
                    debugPrint("\(String(describing: myTitle)): url不存在")
                    CJHUD.cj_showMessage(LocalizedStr("Data exception"))
                }
            }
        }
    }
    
    func loadRawData() {
        CJHUD.cj_showLoadMessage("",interaction: true)
        AF.request(url!).responseString { response in
            CJHUD.cj_hideLoad()
            switch response.result {
            case .success(let htmlString):
                // 成功获取到 HTML 数据，可以在这里处理返回的 HTML 字符串
//                debugPrint("HTML 数据：\(htmlString)")
                self.webView.loadHTMLString(htmlString, baseURL: nil)
            case .failure(let error):
                // 请求失败，打印错误信息
                debugPrint("请求失败：\(error.localizedDescription)")
                CJHUD.cj_showMessage(LocalizedStr("Data exception"))
            }
        }
    }
}
