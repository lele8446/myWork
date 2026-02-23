//
//  CJTool.swift
//  CJMetro
//
//  Created by lele8446 on 2024/4/7.
//

import Foundation
import UIKit
import CommonCrypto
import CryptoKit

let kAppId = "6657990154"

func kAppName()-> String {
    return LocalizedStr("CJ Cleanup")
}


let kLogoColor = 0x2F6DF6


func isDebug()-> Bool {
    var isDebug = false
    #if DEBUG
        isDebug = true
    #else
        isDebug = false
    #endif
    return isDebug
}


class CJTool {
    
}

var keyWindow: UIWindow?
var statusBarManager: UIStatusBarManager?
func initializeGlobalValue() {
    if let windowScence = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScence.windows.first(where: { $0.isKeyWindow }) {
        keyWindow = window
        if let theStatusBarManager = windowScence.statusBarManager {
            statusBarManager = theStatusBarManager
        }
    }
}

//获取安全区域
func safeAreaInsets() -> UIEdgeInsets {
    if (keyWindow == nil) {
        initializeGlobalValue()
    }
    return keyWindow?.safeAreaInsets ?? .zero
}
func topSafeArea() -> CGFloat {
    if (keyWindow == nil) {
        initializeGlobalValue()
    }
    return keyWindow?.safeAreaInsets.top ?? cjStatusBarHeight
}
func bottomSafeArea() -> CGFloat {
    if (keyWindow == nil) {
        initializeGlobalValue()
    }
    return keyWindow?.safeAreaInsets.bottom ?? bottomBarHeight
}

// 状态栏高度
func statusBarHeight() -> CGFloat {
    if (keyWindow == nil) {
        initializeGlobalValue()
    }
    return statusBarManager?.statusBarFrame.height ?? cjStatusBarHeight
}

// 导航栏默认高度
let navHeight: CGFloat = 44.0

// TabBar 默认高度
let tabBarHeight: CGFloat = (bottomSafeArea() + 49.0)

// 状态栏 + 导航栏高度
//let navStatusHeight: CGFloat = (navHeight + statusBarHeight)
let navStatusHeight: CGFloat = (navHeight + topSafeArea())

// 主屏幕宽度
let windowWidth = UIScreen.main.bounds.width

// 主屏幕高度
let windowHeight = UIScreen.main.bounds.height

// 主屏幕高度(去除状态栏)
let windowHeightNoStatus = windowHeight - statusBarHeight()

// 主屏幕高度(去除状态栏 + 导航栏)
let windowHeightNoNavStatus = windowHeight - navStatusHeight

// 是否为 iPhone X 系列设备
var isIPhoneX: Bool {
   let screenHeight = UIScreen.main.bounds.height
   let screenWidth = UIScreen.main.bounds.width
   return (Int((screenHeight / screenWidth) * 100) == 216)
}


// 导航栏高度
let navigationHeight: CGFloat = isIPhoneX ? 88.0 : 64.0

// 状态栏高度
let cjStatusBarHeight: CGFloat = isIPhoneX ? 44.0 : 20.0

// 底部安全区域高度
let bottomBarHeight: CGFloat = isIPhoneX ? 34.0 : 0.0

