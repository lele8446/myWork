//
//  CJContactUsViewController.swift
//  CJMetro
//
//  Created by lele8446 on 2024/4/17.
//

import Foundation
import Cartography

class CJContactUsViewController: UIViewController {
    let button = UIButton(type: .custom)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.layer.shadowColor = UIColor.black.cgColor // 阴影颜色
        button.layer.shadowOpacity = 0.2 // 阴影透明度
        button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5) // 阴影偏移量
        button.layer.shadowRadius = 2 // 阴影模糊半径
        button.layer.masksToBounds = false // 关闭边界遮罩，使得阴影可以显示出来

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.view_color
        
        self.navigationItem.title = LocalizedStr("Contact Us")
        
        let topView = UIView()
        view.addSubview(topView)
        constrain(view, topView) { (view, topView) in
            topView.centerX == view.centerX
            topView.centerY == view.centerY-22
        }
        let color = UIColor.colorFromRGB16(rbgValue: 0x2196ff, alpha: 1)
        let decLabel = UILabel()
        decLabel.numberOfLines = 0
        decLabel.font = UIFont.systemFont(ofSize: 16)
        decLabel.textAlignment = .center
        decLabel.textColor = color
        decLabel.text = "lele8446@foxmail.com"
        topView.addSubview(decLabel)
        constrain(topView, decLabel) { (view, titleLabel) in
            titleLabel.top == view.top
            titleLabel.left == view.left
            titleLabel.height == 30
            titleLabel.bottom == view.bottom
        }
        var image = UIImage(named: "copy")
        image = image!.cj_image(with: color)
        let logoView = UIImageView(image: image)
        logoView.contentMode = .scaleAspectFit
        topView.addSubview(logoView)
        constrain(topView, decLabel, logoView) { (view, decLabel, logoView) in
            logoView.width == 16
            logoView.height == 16
            logoView.left == decLabel.right + 10
            logoView.right == view.right
            logoView.centerY == view.centerY
        }
        let line = UIView()
        line.backgroundColor = UIColor.explain_99
        topView.addSubview(line)
        constrain(topView, decLabel, line) { (view, decLabel, line) in
            line.height == 1
            line.left == view.left
            line.right == decLabel.right
            line.bottom == view.bottom
        }
        topView.isUserInteractionEnabled = true
        let tapGesture0 = UITapGestureRecognizer(target: self, action: #selector(copyClick))
        topView.addGestureRecognizer(tapGesture0)
        
        let str = LocalizedStr("Send Email")
        button.setTitle(str, for: .normal)
        button.setTitleColor(UIColor.logo_color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.clipsToBounds = true
        button.layer.cornerRadius = 22
        button.backgroundColor = UIColor.separator_E8
        button.addTarget(self, action: #selector(emailClick), for: .touchUpInside)
        view.addSubview(button)
        let width = str.stringSize(font: UIFont.systemFont(ofSize: 15)).width + 40
        constrain(view, topView, button) { (view, topView, button) in
            button.height == 44
            button.width == width
            button.centerX == view.centerX
            button.top == topView.bottom + 16
        }
    }
    
    @objc func copyClick() {
        let pasteboard = UIPasteboard.general
        // 将文本设置到剪贴板上
        pasteboard.string = "lele8446@foxmail.com"
        let hud = CJHUD.cj_showMessage("lele8446@foxmail.com\n\(LocalizedStr("Copied to clipboard."))")
        hud?.offset = CGPoint(x: 0, y: -90)
    }
    
    @objc func emailClick() {
        sendEmail(to: "lele8446@foxmail.com", subject: "", body: "")
    }
    
    func sendEmail(to: String, subject: String, body: String) {
        if let url = URL(string: "mailto:\(to)") {
            // 检查是否有应用可以处理mailto URL scheme
            if UIApplication.shared.canOpenURL(url) {
                // 打开邮件客户端
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // 没有应用可以处理mailto URL scheme
                debugPrint("没有找到可以处理的应用来打开邮件。")
                let hud = CJHUD.cj_showMessage(LocalizedStr("Email app not installed."))
                hud?.offset = CGPoint(x: 0, y: -90)
            }
        }
    }
}
