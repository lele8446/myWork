//
//  CJUpdateView.swift
//  CJMetro
//
//  Created by lele8446 on 2024/4/18.
//

import Foundation
import UIKit
import Cartography


class CJUpdateView: UIView {
    var bgView: UIView = UIView()
    var imgBgView: UIView = UIView()
    var imgView: UIImageView = UIImageView()
    var titleLabel: UILabel = UILabel()
    var decLabel: UILabel = UILabel()
    var button: UIButton = UIButton()
    var link: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
    }
    //如果自定义视图是通过 Interface Builder 或 Storyboard 创建的，那么编译器会要求你实现 init?(coder: NSCoder) 方法
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        
        let width = windowWidth - 65.0 * 2
//        let height = width * 200 / 255.0
        self.addSubview(self.bgView)
        bgView.backgroundColor = UIColor.white
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 12
        self.addSubview(bgView)
        constrain(self, bgView) { (view, bgView) in
            bgView.centerY == view.centerY-45
            bgView.centerX == view.centerX
            bgView.width == width
//            bgView.height == width
        }
        
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 45
        self.addSubview(topView)
        constrain(self, bgView, topView) { (view, bgView, topView) in
            topView.top == bgView.top - 45
            topView.centerX == view.centerX
            topView.width == 90
            topView.height == 90
        }
        imgBgView.backgroundColor = UIColor.logo_color.withAlphaComponent(0.05)
        imgBgView.clipsToBounds = true
        imgBgView.layer.cornerRadius = 45
        topView.addSubview(imgBgView)
        constrain(topView, imgBgView) { (view, imgBgView) in
            imgBgView.top == view.top
            imgBgView.bottom == view.bottom
            imgBgView.left == view.left
            imgBgView.right == view.right
        }
        
        var img = UIImage(named: "update")
        img = img!.cj_image(with: UIColor.logo_color)
        imgView.image = img
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
//        imgView.layer.cornerRadius = 30
        imgBgView.addSubview(imgView)
        constrain(imgBgView, imgView) { (imgBgView, imgView) in
            imgView.centerY == imgBgView.centerY
            imgView.centerX == imgBgView.centerX
            imgView.width == 35
            imgView.height == 35
        }
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18);
        self.titleLabel.text = LocalizedStr("New version available")
        self.titleLabel.textColor = UIColor.title_33
        bgView.addSubview(self.titleLabel)
        constrain(bgView, self.titleLabel) { (view, label) in
            label.top == view.top + 45 + 20
            label.left == view.left+10
            label.right == view.right-10
        }
        
        self.decLabel.numberOfLines = 0
        self.decLabel.textAlignment = NSTextAlignment.left
        self.decLabel.font = UIFont.systemFont(ofSize: 14);
        self.decLabel.attributedText = dec()
        self.decLabel.textColor = UIColor.title_33
        bgView.addSubview(self.decLabel)
        constrain(bgView, titleLabel, self.decLabel) { (view, titleLabel, label) in
            label.top == titleLabel.bottom + 14
//            label.left == view.left+10
//            label.right == view.right-10
            label.centerX == view.centerX
            label.width <= width-20
        }
        
        let str = LocalizedStr("Update Now")
        button.setTitle(str, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor.logo_color.withAlphaComponent(0.95)
        button.addTarget(self, action: #selector(updateClick), for: .touchUpInside)
        bgView.addSubview(button)
//        let btnWidth = str.stringSize(font: UIFont.systemFont(ofSize: 15)).width + 80
        constrain(bgView, decLabel, button) { (view, decLabel, button) in
            button.height == 44
//            button.width == btnWidth
            button.centerX == view.centerX
            button.top == decLabel.bottom + 20
            button.bottom == view.bottom - 40
            button.left == view.left + 25
            button.right == view.right - 25
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.white
        self.addSubview(line)
        constrain(self, bgView, line) { (view, bgView, line) in
            line.centerX == view.centerX
            line.top == bgView.bottom
            line.width == 1.5
            line.height == 50
        }
        let close = UIImageView()
        close.image = UIImage(named: "close_update")
        self.addSubview(close)
        constrain(self, line, close) { (view, line, close) in
            close.height == 40
            close.width == 40
            close.top == line.bottom
            close.centerX == view.centerX
        }
        close.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        close.addGestureRecognizer(tapGesture)
        
    }
    
    func dec() -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        // 设置行间距
        let style = NSMutableParagraphStyle()
        // 间隙
        style.lineSpacing = 8
//        style.alignment = .center
        let font = UIFont.systemFont(ofSize: 14)
        let fontAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.title_33,
            .font: font,
            .paragraphStyle: style
        ]
        
        var image = UIImage(named: "selected")
        image = image?.cj_image(with: UIColor.logo_color)
        let attachment = NSTextAttachment()
        attachment.image = image
        // 设置NSTextAttachment的属性以调整图片大小
        attachment.bounds = CGRect(x: 0, y: round(font.capHeight - 14)/2.0, width: 14, height: 14)
        let imageString = NSAttributedString(attachment: attachment)
        
        attributedString.append(imageString)
        let string = NSAttributedString(string: " \(LocalizedStr("Fixed some known issues."))\n", attributes: fontAttributes)
        attributedString.append(string)
        
        attributedString.append(imageString)
        let string2 = NSAttributedString(string: " \(LocalizedStr("Optimized user experience."))", attributes: fontAttributes)
        attributedString.append(string2)
        
        attributedString.addAttributes(fontAttributes, range: NSRange(location: 0, length: attributedString.length))
         
        return attributedString
    }
    
    @objc func updateClick() {
        self.hidePopup()
        let url = URL(string: (link ?? ""))
        if(url != nil){
            UIApplication.shared.open(url!)
        }else{
            CJHUD.cj_showMessage(LocalizedStr("Operation error."))
        }
    }
    
    @objc func closeTapped() {
        self.hidePopup()
    }

    func hidePopup(){
        self.alpha = 1.0
        UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0.0
            }) { _ in
                self.removeFromSuperview()
            }
    }
    
    static func show(link: String){
        let view = CJUpdateView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: windowHeight))
        view.link = link        
        if let windowScence = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScence.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(view)
        }else{
            UIApplication.shared.keyWindow?.addSubview(view)
        }
    }
}
