//
//  Reachability.swift
//  CJMetro
//
//  Created by lele8446 on 2024/4/7.
//

import Foundation
import SystemConfiguration
 
public class Reachability {
 
    class func isConnectedToNetwork() -> Bool {
 
        var zeroAddress = sockaddr_storage()
        zeroAddress.ss_len = __uint8_t(MemoryLayout<sockaddr_storage>.size)
        zeroAddress.ss_family = sa_family_t(AF_INET)
 
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
 
        var flags: SCNetworkReachabilityFlags = []
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
 
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
 
        return isReachable && !needsConnection
    }
}
