//
//  CJCategray.swift
//  CJTranslate
//
//  Created by lele8446 on 2024/8/20.
//

import Foundation
import CryptoKit

extension UIImage {
    // 修正图片方向的方法
    func fixOrientation() -> UIImage {
        guard imageOrientation != .up else {
            return self
        }
        return UIGraphicsImageRenderer(size: CGSize(width: size.width, height: size.height)).image {_ in
            draw(at: .zero)
        }
    }
    
}

extension UIButton {
    func enableClick(_ enable: Bool) {
        self.isEnabled = enable
        self.alpha = enable ? 1.0 : 0.70
    }
}


extension String {
    func md5() -> String {
        
        if let data = self.data(using: .utf8) {
            let digest = Insecure.MD5.hash(data: data)
            let result = digest.map { String(format: "%02x", $0) }.joined()
            return result
        }
        return ""
    }
    
    func stringSize(font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: attributes)
        return size
    }
    
    func jsonStrEscaped() -> String {
        let str = self.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\t", with: "\\t")
            .replacingOccurrences(of: "·", with: "\\u00B7")
            .replacingOccurrences(of: "&", with: "\\u0026")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "/", with: "\\/")
            .replacingOccurrences(of: "<", with: "\\u003C")
            .replacingOccurrences(of: ">", with: "\\u003E")
            .replacingOccurrences(of: "\u{08}", with: "\\b")
            .replacingOccurrences(of: "\u{0C}", with: "\\f")
            .replacingOccurrences(of: "\u{0B}", with: "\\v")
            .replacingOccurrences(of: "\u{07}", with: "\\a")
            .replacingOccurrences(of: "！", with: "\\uFF01")
            .replacingOccurrences(of: "@", with: "\\u0040")
            .replacingOccurrences(of: "#", with: "\\u0023")
            .replacingOccurrences(of: "¥", with: "\\u00A5")
            .replacingOccurrences(of: "%", with: "\\u0025")
            .replacingOccurrences(of: "*", with: "\\u002A")
            .replacingOccurrences(of: "(", with: "\\u0028")
            .replacingOccurrences(of: ")", with: "\\u0029")
            .replacingOccurrences(of: "（", with: "\\uFF08")
            .replacingOccurrences(of: "）", with: "\\uFF09")
            .replacingOccurrences(of: "-", with: "\\u002D")
        return str
    }
    
    func strWithoutEnter()-> String {
        let str = self.replacingOccurrences(of: "\n", with: " ")
        return str
    }
}

extension UIColor {
    static func colorFromRGB16(rbgValue: UInt, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat((rbgValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rbgValue & 0xFF00) >> 8) / 255.0,
                       blue: CGFloat((rbgValue & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    
    static func colorFromRGB10(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    static func colorFromHexString(hexString: String, alpha: CGFloat? = 1) -> UIColor {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        return UIColor.colorFromRGB16(rbgValue: UInt(rgbValue), alpha: alpha ?? 1)
    }
    
    static var title_33: UIColor { return UIColor.colorFromRGB16(rbgValue: 0x333333, alpha: 1)}
    static var subtitle_66: UIColor { return UIColor.colorFromRGB16(rbgValue: 0x666666, alpha: 1)}
    static var subtitle_88: UIColor { return UIColor.colorFromRGB16(rbgValue: 0x888888, alpha: 1)}
    static var explain_99: UIColor { return UIColor.colorFromRGB16(rbgValue: 0x999999, alpha: 1)}
    static var hint_C7: UIColor { return UIColor.colorFromRGB16(rbgValue: 0xC7C7C7, alpha: 1)}
    static var separator_E8: UIColor { return UIColor.colorFromRGB16(rbgValue: 0xE8E8E8, alpha: 1)}
    static var view_color: UIColor { return UIColor.colorFromRGB16(rbgValue: 0xF2F2F2, alpha: 1)}
    static var logo_color: UIColor { return UIColor.colorFromRGB16(rbgValue: UInt(kLogoColor), alpha: 1)}
    
}
