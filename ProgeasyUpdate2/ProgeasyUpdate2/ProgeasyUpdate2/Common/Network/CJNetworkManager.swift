//
//  CJNetworkManager.swift
//  CJMetro
//
//  Created by lele8446 on 2024/4/16.
//

import Foundation
import Alamofire
 
// 定义回调闭包，处理响应结果
typealias NetworkCompletionClosure = (Result<Any, Error>) -> Void
 
// 定义用于管理网络请求的类
class CJNetworkManager {
 
    // 发送一个GET请求到指定的URL，并使用指定的回调处理响应
    class func performGETRequest<T: Decodable>(url: String, headers:HTTPHeaders?, type: T.Type = T.self, completion: @escaping NetworkCompletionClosure) {
        AF.request(url,headers: headers).responseDecodable(of: type, completionHandler: { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
//        responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                completion(.success(value))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
    
    // 发送一个POST请求
    class func performPoastRequest<T: Decodable>(url: String, headers:HTTPHeaders?, parameters: Parameters?, type: T.Type = T.self, completion: @escaping NetworkCompletionClosure) {
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: type, completionHandler: { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
//        responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                completion(.success(value))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}
 
//// 使用示例
//NetworkManager.performGETRequest(url: "https://api.example.com/data") { result in
//    switch result {
//    case .success(let data):
//        debugPrint("成功获取数据: \(data)")
//    case .failure(let error):
//        debugPrint("网络请求失败: \(error)")
//    }
//}
