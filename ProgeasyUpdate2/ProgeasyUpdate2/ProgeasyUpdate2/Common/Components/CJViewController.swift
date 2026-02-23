//
//  CJViewController.swift
//  CJMetro
//
//  Created by C.K.Lian on 2024/4/25.
//

import Foundation
import UIKit
import Cartography

extension UIViewController {
    func showAlert(title:String, message:String, ok:String, okBlock: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title:ok, style: .default) { (action) in
            okBlock();
        }
        alertController.addAction(action1)
        present(alertController, animated: true, completion: nil)
    }
    func showAlert(title:String, message:String, ok:String, cancel:String, okBlock: @escaping () -> Void, cancelBlock: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title:ok, style: .default) { (action) in
            okBlock();
        }
        let action2 = UIAlertAction(title:cancel, style: .destructive) { (action) in
            cancelBlock()
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        present(alertController, animated: true, completion: nil)
    }
    
    func topMostViewController() -> UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topMostViewController()
        }
        
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topMostViewController() ?? navigationController
        }
        
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? tabBarController
        }
        
        return self
    }
}


class CJViewController: UIViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
