//
//  CJCommonHelper.swift
//  CJMetro
//
//  Created by lele8446 on 2024/4/17.
//

import Foundation
import UIKit
import StoreKit

let CJAppStartTimeKey = "CJAppStartTimeKey"
let CJ_USER_DEFAULT = UserDefaults.standard

func LocalizedStr(_ str: String)-> String {
    return NSLocalizedString(str, comment: "")
}

class CJCommonHelper {
    deinit {
        debugPrint("CJCommonHelper dealloc")
    }

    static func gotoRateUs() {
        if let time = CJ_USER_DEFAULT.value(forKey: CJAppStartTimeKey) as? NSNumber,
           let timeNum = time as? Int,
           timeNum > 9 && (timeNum % 10 == 0) {
            if #available(iOS 14.0, *) {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                if SKStoreReviewController.responds(to: #selector(SKStoreReviewController.requestReview(in:))) {
                    SKStoreReviewController.requestReview(in: windowScene!)
                }
            } else if #available(iOS 10.3, *) {
                if SKStoreReviewController.responds(to: #selector(SKStoreReviewController.requestReview)) {
                    SKStoreReviewController.requestReview()
                }
            }
        }
    }

    static func addAppStartTime() {
        if var time = CJ_USER_DEFAULT.value(forKey: CJAppStartTimeKey) as? NSNumber {
            if time.intValue < 100000 {
                time = NSNumber(value: time.intValue + 1)
            }
            CJ_USER_DEFAULT.setValue(time, forKey: CJAppStartTimeKey)
            CJ_USER_DEFAULT.synchronize()
        } else {
            let time = NSNumber(value: 1)
            CJ_USER_DEFAULT.setValue(time, forKey: CJAppStartTimeKey)
            CJ_USER_DEFAULT.synchronize()
        }
    }
}
