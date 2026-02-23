//
//  PHAsset+CJ.swift
//  CJClean
//
//  Created by lele8446 on 2025/8/3.
//

extension PHAsset {
    private static var sizeKey: Void?
//    private struct AccociatedKey {
//        static var sizeKey = "CJ.PHAsset.sizeKey"
//    }
    var size: Int64? {
        get {
            return objc_getAssociatedObject(self, &PHAsset.sizeKey) as? Int64
        }
        set {
            objc_setAssociatedObject(self, &PHAsset.sizeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static var selectKey: Void?
    var select: Bool {
        get {
            let result = objc_getAssociatedObject(self, &PHAsset.selectKey)
            guard result != nil else {
                return false
            }
            return result as! Bool
        }
        set {
            objc_setAssociatedObject(self, &PHAsset.selectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static var sha256Key: Void?
    var sha256: String? {
        get {
            return objc_getAssociatedObject(self, &PHAsset.sha256Key) as? String
        }
        set {
            objc_setAssociatedObject(self, &PHAsset.sha256Key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
