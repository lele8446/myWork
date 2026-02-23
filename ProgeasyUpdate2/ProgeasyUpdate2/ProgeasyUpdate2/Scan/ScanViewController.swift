//
//  ScanViewController.swift
//  CJTranslate
//
//  Created by lele8446 on 2024/8/19.
//

import UIKit
import AVFoundation
import Cartography
import AudioToolbox
import Photos
import Foundation
import CryptoKit


class ScanState {
    private let queue = DispatchQueue(label: "com.cjclean.scanStateQueue")
    private var _isScanning = false

    var isScanning: Bool {
        get {
            return queue.sync { _isScanning }
        }
        set {
            queue.sync { _isScanning = newValue }
        }
    }
}

extension Notification.Name {
    static let tabCustomButtonTappedNotification = Notification.Name("kCJTabCustomButtonTapped")
}

class ScanViewController: CJViewController {
    
    private let titleLabel = UILabel()
    var languageChangeObserver: NSObjectProtocol?
    var tabClickObserver: NSObjectProtocol?
    var backView: UIImageView = UIImageView()
    let scanButton = ScanButtonView(frame: CGRect(x: 0, y: 0, width: 170.0, height: 170.0), scanEnableBlock: nil)
    private let statusLabel = UILabel()
    private let scanState = ScanState()
    var scanHeadView: UIImageView = UIImageView()
    private var settingBtn: UIButton?
    
    
    deinit {
        if let languageChangeObserver = languageChangeObserver {
            NotificationCenter.default.removeObserver(languageChangeObserver, name: .languageChangeNotification, object: nil)
        }
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        languageChangeObserver = NotificationCenter.default.addObserver(forName: .languageChangeNotification, object: nil, queue: .main) { _ in
            self.loadDataFromSetting()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        view.backgroundColor = UIColor.white
        self.hbd_barAlpha = 0
        
        let setting = UIBarButtonItem(customView: scanSettingBtn())
        self.navigationItem.rightBarButtonItem = setting
        
        setupUI()
        loadDataFromSetting()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func loadDataFromSetting() {
//        self.title = ""
        titleLabel.text = LocalizedStr("CJ Cleanup")
        statusLabel.text = LocalizedStr("Ready to scan")
    }
    
    private func scanSettingBtn() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        btn.contentHorizontalAlignment = .right
        let image = UIImage(named: "scan_setting")
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(clickScanSetting), for: .touchUpInside)
        self.settingBtn = btn
        return self.settingBtn!
    }
    
    private func setupUI() {
        titleLabel.text = LocalizedStr("CJ Cleanup")
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        self.navigationItem.titleView = titleLabel
        
        backView.image = UIImage(named: "scan_back_view")
        view.addSubview(backView)
        constrain(backView, view) { backView, view in
            backView.top == view.top - navStatusHeight
            backView.bottom == view.bottom
            backView.left == view.left
            backView.right == view.right
        }
        
        let scanImage = UIImage(named: "scan_home")
        scanHeadView.image = scanImage
        scanHeadView.alpha = 0.70
        view.addSubview(scanHeadView)
        constrain(scanHeadView, view) { scanHeadView, view in
            scanHeadView.top == view.top + 45*windowHeight/844.0
            scanHeadView.left == view.left + 60*windowWidth/390.0
            scanHeadView.right == view.right - 70*windowWidth/390.0
            scanHeadView.height == scanHeadView.width * (441.0/500.0)
        }
        
        scanButton.scanEnableBlc = { [weak self] isScanning in
            self?.clickScanButton(isScanning)
        }
        view.addSubview(scanButton)
        constrain(scanButton, view) { backView, view in
            backView.width == 170
            backView.height == 170
            backView.bottom == view.bottom - 140
            backView.centerX == view.centerX
        }
    }
    
    func clickScanButton(_ isScanning: Bool) {
    }


    func settingSystem() {
        let url = NSURL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
    
    @objc func clickScanSetting() {
        
    }
    
}

