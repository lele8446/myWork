//
//  CJView.swift
//  CJMetro
//
//  Created by lele8446 on 2024/4/7.
//

import Foundation
import UIKit
import Cartography


let kErrorNetTag = 2447
let kEmpthDataTag = 2448
let kErrorDataTag = 2449
let kCustomTag = 2450
 
enum HandlerType {
    case netWorkError
    case empty
    case dataError
    case custom
}
typealias HandlerBlock = (_ type: HandlerType) -> Bool/*根据返回结果判断是否自动移除view*/
private var handlerKey: Void?
private var emptyHandlerKey: Void?
private var errorDataHandlerKey: Void?
private var customHandlerKey: Void?

extension UIView {
    func roundingCorners (corners: UIRectCorner, cornerRadius: CGFloat) {
        // 创建圆角路径
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))

        // 创建CAShapeLayer
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath

        // 将CAShapeLayer设置为视图控制器的mask
        self.layer.mask = maskLayer
    }
    
    private var handler: HandlerBlock? {
        get {
            return objc_getAssociatedObject(self, &handlerKey) as! HandlerBlock?
        }
        set {
            objc_setAssociatedObject(self, &handlerKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    private var emptyHandler: HandlerBlock? {
        get {
            return objc_getAssociatedObject(self, &emptyHandlerKey) as! HandlerBlock?
        }
        set {
            objc_setAssociatedObject(self, &emptyHandlerKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    private var errorDataHandler: HandlerBlock? {
        get {
            return objc_getAssociatedObject(self, &errorDataHandlerKey) as! HandlerBlock?
        }
        set {
            objc_setAssociatedObject(self, &errorDataHandlerKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    private var customHandler: HandlerBlock? {
        get {
            return objc_getAssociatedObject(self, &customHandlerKey) as! HandlerBlock?
        }
        set {
            objc_setAssociatedObject(self, &customHandlerKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    private func view(_ x: CGFloat, _ y: CGFloat, theName: String?, theTitle: String?, type: HandlerType) -> UIView {
        var tag = -100
        if(type == .netWorkError){
            tag = kErrorNetTag
        }
        else if(type == .empty){
            tag = kEmpthDataTag
        }
        else if(type == .dataError){
            tag = kErrorDataTag
        }
        else if(type == .custom){
            tag = kCustomTag
        }
        var myView = self.viewWithTag(tag)
        if(myView != nil && myView!.isHidden == false){
            myView!.removeFromSuperview()
            myView = nil
        }
        
        let errorView = UIView(frame: CGRect(x: x, y: y, width: 200, height: 200))
        errorView.isUserInteractionEnabled = true
        self.addSubview(errorView)
        self.bringSubviewToFront(errorView)
        constrain(self, errorView) { (view, errorView) in
            errorView.centerX == view.centerX + x
            errorView.centerY == view.centerY + y
        }
        var title = "Click to retry"
        var name = "results_def_network_error"
        if(type == .netWorkError){
            errorView.tag = kErrorNetTag
            name = theName ?? "results_def_network_error"
            title = theTitle ?? "Network error, click to retry"
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            errorView.addGestureRecognizer(tapGesture)
        }
        else if(type == .empty){
            errorView.tag = kEmpthDataTag
            name = theName ?? "results_def_content_empty"
            title = theTitle ?? "No data"
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emptyTapAction))
            errorView.addGestureRecognizer(tapGesture)
        }
        else if(type == .dataError){
            errorView.tag = kErrorDataTag
            name = theName ?? "results_def_access_failure"
            title = theTitle ?? "Click to retry"
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(errorDataTapAction))
            errorView.addGestureRecognizer(tapGesture)
        }
        else if(type == .custom){
            errorView.tag = kCustomTag
            name = theName ?? "results_def_content_empty"
            title = theTitle ?? ""
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customTapAction))
            errorView.addGestureRecognizer(tapGesture)
        }
        let imgView = UIImageView(image: UIImage(named: name))
        errorView.addSubview(imgView)
        constrain(errorView, imgView) { (errorView, imgView) in
            imgView.top == errorView.top
            imgView.left == errorView.left
            imgView.right == errorView.right
            imgView.width == 200
            imgView.height == 200
        }
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.explain_99
        label.text = LocalizedStr(title)
        errorView.addSubview(label)
        constrain(errorView, imgView, label) { (errorView, imgView, label) in
            label.top == imgView.bottom + 4
            label.bottom == errorView.bottom
            label.left == errorView.left
            label.right == errorView.right
        }
        return errorView
    }
    
    func hideErrorNetWork () {
        let errorView = self.viewWithTag(kErrorNetTag)
        errorView?.removeFromSuperview()
    }
    func errorNetWork(_ x: CGFloat = 0, _ y: CGFloat = 0, handler: @escaping HandlerBlock) {
        let errorView = view(x, y, theName: nil, theTitle: nil, type: .netWorkError)
        errorView.tag = kErrorNetTag
        self.handler = handler
    }
    
    func empthData(_ x: CGFloat = 0, _ y: CGFloat = 0, handler: HandlerBlock?) {
        let errorView = view(x, y, theName: nil, theTitle: nil, type: .empty)
        errorView.tag = kEmpthDataTag
        self.emptyHandler = handler
    }
    func hideEmpthData () {
        let errorView = self.viewWithTag(kEmpthDataTag)
        errorView?.removeFromSuperview()
    }
    
    func errorData(_ x: CGFloat = 0, _ y: CGFloat = 0, handler: HandlerBlock?) {
        let errorView = view(x, y, theName: nil, theTitle: nil, type: .dataError)
        errorView.tag = kErrorDataTag
        self.errorDataHandler = handler
    }
    func hideErrorData () {
        let errorView = self.viewWithTag(kErrorDataTag)
        errorView?.removeFromSuperview()
    }
    
    func customTip(x: CGFloat = 0, y: CGFloat = 0, imgName: String, title: String?, handler: HandlerBlock?) {
        let errorView = view(x, y, theName: imgName, theTitle: title, type: .custom)
        errorView.tag = kCustomTag
        self.customHandler = handler
    }
    func hideCustomTip () {
        let errorView = self.viewWithTag(kCustomTag)
        errorView?.removeFromSuperview()
    }
    
    @objc private func tapAction(gesture: UITapGestureRecognizer) {
        let errorView = self.viewWithTag(kErrorNetTag)
        if(self.handler != nil){
            let result = self.handler!(.netWorkError)
            if(result){
                errorView?.removeFromSuperview()
            }
        }
    }
    @objc private func emptyTapAction(gesture: UITapGestureRecognizer) {
        let emptyView = self.viewWithTag(kEmpthDataTag)
        if(self.emptyHandler != nil){
            let result = self.emptyHandler!(.empty)
            if(result){
                emptyView?.removeFromSuperview()
            }
        }
    }
    @objc private func errorDataTapAction(gesture: UITapGestureRecognizer) {
        let emptyView = self.viewWithTag(kErrorDataTag)
        if(self.errorDataHandler != nil){
            let result = self.errorDataHandler!(.dataError)
            if(result){
                emptyView?.removeFromSuperview()
            }
        }
    }
    @objc private func customTapAction(gesture: UITapGestureRecognizer) {
        let emptyView = self.viewWithTag(kCustomTag)
        if(self.customHandler != nil){
            let result = self.customHandler!(.custom)
            if(result){
                emptyView?.removeFromSuperview()
            }
        }
    }
}

extension UIView {
    
    @discardableResult
    func addGradient(colors: [UIColor],
                     point: (CGPoint, CGPoint) = (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1)),
                     locations: [NSNumber] = [0, 1],
                     frame: CGRect = CGRect.zero,
                     radius: CGFloat = 0,
                     at: UInt32 = 0) -> CAGradientLayer {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = colors.map { $0.cgColor }
        bgLayer1.locations = locations
        if frame == .zero {
            bgLayer1.frame = self.bounds
        } else {
            bgLayer1.frame = frame
        }
        bgLayer1.startPoint = point.0
        bgLayer1.endPoint = point.1
        bgLayer1.cornerRadius = radius
        self.layer.insertSublayer(bgLayer1, at: at)
        return bgLayer1
    }
    
    func addGradient(start: CGPoint = CGPoint(x: 0.5, y: 0),
                     end: CGPoint = CGPoint(x: 0.5, y: 1),
                     colors: [UIColor],
                     locations: [NSNumber] = [0, 1],
                     frame: CGRect = CGRect.zero,
                     radius: CGFloat = 0,
                     at: UInt32 = 0) {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = colors.map { $0.cgColor }
        bgLayer1.locations = locations
        bgLayer1.frame = frame
        bgLayer1.startPoint = start
        bgLayer1.endPoint = end
        bgLayer1.cornerRadius = radius
        self.layer.insertSublayer(bgLayer1, at: at)
    }
    
    func addGradient(start_color :String, end_color : String,frame : CGRect?=nil,cornerRadius : CGFloat?=0, at: UInt32 = 0){
        var bounds : CGRect = self.bounds
        if let frame = frame {
            bounds = frame
        }
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [
            UIColor.colorFromHexString(hexString: start_color).cgColor,
            UIColor.colorFromHexString(hexString: end_color).cgColor
        ]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = bounds
        bgLayer1.startPoint = CGPoint(x: 0, y: 0.61)
        bgLayer1.endPoint = CGPoint(x: 0.61, y: 0.61)
        bgLayer1.cornerRadius = cornerRadius ?? 0
        self.layer.insertSublayer(bgLayer1, at: at)
    }
    
    func addGradient(start_color:String,
                     end_color : String,
                     frame : CGRect?=nil,
                     borader: CGFloat = 0,
                     boraderColor: UIColor = .clear,
                     at: UInt32 = 0,
                     corners: UIRectCorner?,
                     radius: CGFloat = 0) {
        var bounds : CGRect = self.bounds
        if let frame = frame {
            bounds = frame
        }
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [
            UIColor.colorFromHexString(hexString: start_color).cgColor,
            UIColor.colorFromHexString(hexString: end_color).cgColor
        ]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = bounds
        bgLayer1.startPoint = CGPoint(x: 0, y: 0.61)
        bgLayer1.endPoint = CGPoint(x: 0.61, y: 0.61)
        bgLayer1.borderColor = boraderColor.cgColor
        bgLayer1.borderWidth = borader
        if corners != nil {
            let cornerPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners!, cornerRadii: CGSize(width: radius, height: radius))
            let radiusLayer = CAShapeLayer()
            radiusLayer.frame = bounds
            radiusLayer.path = cornerPath.cgPath
            bgLayer1.mask = radiusLayer
        }
        self.layer.insertSublayer(bgLayer1, at: at)
    }
    
    func addGradient(startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                     start_color:String,
                     endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
                     end_color : String,
                     frame : CGRect? = nil,
                     cornerRadius : CGFloat?=0){
        var bounds : CGRect = self.bounds
        if let frame = frame {
            bounds = frame
        }
        let bgLayer1 = CAGradientLayer()
        bgLayer1.frame = bounds
        bgLayer1.startPoint = startPoint
        bgLayer1.endPoint = endPoint
        bgLayer1.colors = [
            UIColor.colorFromHexString(hexString: start_color).cgColor,
            UIColor.colorFromHexString(hexString: end_color).cgColor
        ]
        bgLayer1.locations = [0, 1]
        bgLayer1.cornerRadius = cornerRadius ?? 0
        self.layer.addSublayer(bgLayer1)
    }
    
    func addVerticalGradient(start_color:String,end_color : String,frame : CGRect?=nil,cornerRadius : CGFloat?=0){
        var bounds : CGRect = self.bounds
        if let frame = frame {
            bounds = frame
        }
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [
            UIColor.colorFromHexString(hexString: start_color).cgColor,
            UIColor.colorFromHexString(hexString: end_color).cgColor
        ]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = bounds
        bgLayer1.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer1.endPoint = CGPoint(x: 1, y: 1)
        bgLayer1.cornerRadius = cornerRadius ?? 0
        self.layer.insertSublayer(bgLayer1, at: 0)
    }
    
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView {
    func snapshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            layer.render(in: ctx.cgContext)
        }
    }
}
