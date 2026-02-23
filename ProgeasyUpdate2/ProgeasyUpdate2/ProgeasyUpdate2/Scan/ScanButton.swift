//
//  ScanButton.swift
//  CJClean
//
//  Created by apple on 2025/4/30.
//

import Foundation
import Cartography

typealias ScanEnableBlock = (Bool) -> Void

class ScanButtonView : UIView {
    
    private let scanButton = UIButton(type: .system)
    private let backView = UIView()
    private let progressView = UIView()
    private let progressLayer = CAShapeLayer()
    private let pulseView = UIView()
    private var pulseLayer = CAShapeLayer()
    
    private var width: CGFloat = 0.0
    private var isScanning = false
    private var progress: CGFloat = 0.0
    private var lastProgressUpdateTime: TimeInterval = 0
    private let progressUpdateInterval: TimeInterval = 0.05 // 限制刷新频率
    private let animationDuration: CFTimeInterval = 0.1
    
    private let scanLabel = UILabel()
    private let scanSubLabel = UILabel()
    
    var scanEnableBlc: ScanEnableBlock?
    
    private let left : CGFloat = 20.0
    
    init(frame: CGRect, scanEnableBlock: ScanEnableBlock?) {
        super.init(frame: frame)
        scanEnableBlc = scanEnableBlock
        width = self.frame.width
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        let backWidth = (width*1.3)
//        let centerColor = UIColor.colorFromHexString(hexString: "#A0C4FF").withAlphaComponent(1)
//        applyRadialGradient(to: backView, centerColor: UIColor.red, radius: backWidth / 2.0)
    }
    
    private func setupView() {        
//        scanButton.setTitle(LocalizedStr("Start"), for: .normal)
        scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        scanButton.backgroundColor = UIColor.logo_color.withAlphaComponent(0.85)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.layer.cornerRadius = (width - 2*left)/2.0
//        scanButton.clipsToBounds = true
        self.scanButton.layer.borderWidth = 1.5
        self.scanButton.layer.borderColor = UIColor.colorFromRGB10(255, 255, 255, 0.85).cgColor
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        self.addSubview(scanButton)
        self.scanButton.layer.shadowColor = UIColor.title_33.cgColor
        self.scanButton.layer.shadowOffset = CGSizeMake(0, 3)
        self.scanButton.layer.shadowOpacity = 0.45
        self.scanButton.layer.shadowRadius = 4
        constrain(scanButton, self) { button, container in
            button.top == container.top + left
            button.bottom == container.bottom - left
            button.left == container.left + left
            button.right == container.right - left
        }
        
        scanLabel.font = UIFont.boldSystemFont(ofSize: 22)
        scanLabel.textAlignment = .center
        scanLabel.textColor = .white
        scanLabel.adjustsFontSizeToFitWidth = true
        scanLabel.minimumScaleFactor = 0.8
        scanButton.addSubview(scanLabel)
        scanLabel.text = LocalizedStr("Start")
        constrain(scanLabel, scanButton) { button, container in
            button.top == container.top
            button.bottom == container.bottom - 8
            button.left == container.left
            button.right == container.right
        }
        
        scanSubLabel.font = UIFont.systemFont(ofSize: 13)
        scanSubLabel.textAlignment = .center
        scanSubLabel.textColor = UIColor.colorFromRGB10(255, 255, 255, 0.75)
        scanButton.addSubview(scanSubLabel)
        scanSubLabel.text = ""
        constrain(scanSubLabel, scanLabel, scanButton) { button, scanLabel, container in
            button.centerY == container.centerY + 24
            button.height == 20
            button.left == container.left
            button.right == container.right
        }
        
        let backWidth = (width*1.6)
//        backView.layer.cornerRadius = (backWidth)/2.0
        backView.frame  = CGRect(x: 0, y: 0, width: backWidth, height: backWidth)
        backView.center = self.center
        let centerColor = UIColor.logo_color.withAlphaComponent(0.55) //UIColor.colorFromHexString(hexString: "#A0C4FF")
        applyRadialGradient(to: backView, centerColor: centerColor, radius: backWidth / 2.0)
        self.insertSubview(backView, belowSubview: scanButton)
        
        addProgressCircle()
    }
    private func addProgressCircle() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: width/2.0, y: width/2.0),
                                        radius: (width - left)/2.0,
                                        startAngle: -.pi / 2,
                                        endAngle: 1.5 * .pi,
                                        clockwise: true)

        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.colorFromHexString(hexString: "#00bfa5").cgColor
//        progressLayer.strokeColor = UIColor.colorFromHexString(hexString: "#39ff14").cgColor
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = left
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        progressView.layer.addSublayer(progressLayer)
        self.insertSubview(progressView, belowSubview: scanButton)
        constrain(progressView, scanButton) { circle, button in
            circle.center == button.center
            circle.width == width
            circle.height == width
        }
    }
    
    func updateTitle() {
        scanLabel.text = isScanning ? LocalizedStr("Stop") : LocalizedStr("Start")
    }
    
    func finish() {
        resetAnimation()
        isScanning = false
//        scanButton.setTitle(isScanning ? LocalizedStr("Stop") : LocalizedStr("Start"), for: .normal)
        scanLabel.text = isScanning ? LocalizedStr("Stop") : LocalizedStr("Start")
        scanSubLabel.text = ""
    }
    private func resetAnimation() {
        progressView.isHidden = true
        progressLayer.removeAllAnimations()
        progressLayer.strokeEnd = 0
        progress = 0
        lastProgressUpdateTime = 0
        hidePulse()
    }

    func updateProgress(progressValue: CGFloat) {
        if !isScanning {
            return
        }
        
        scanSubLabel.text = String(format: "%.0f%%", progress * 100)
        progressView.isHidden = false
        progress = progressValue
        let now = Date().timeIntervalSince1970
        guard now - lastProgressUpdateTime >= progressUpdateInterval || progress == 1.0 else {
            if (progress == 1.0) {
                finish()
            }
            return
        }
        lastProgressUpdateTime = now

        DispatchQueue.main.async {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = self.progressLayer.presentation()?.strokeEnd ?? self.progressLayer.strokeEnd
            animation.toValue = self.progress
            animation.duration = self.animationDuration
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            self.progressLayer.removeAnimation(forKey: "progress")
            self.progressLayer.add(animation, forKey: "progress")

        }
    }
    
    func updateScanButtonStatues() {
        isScanning.toggle()
//        scanButton.setTitle(isScanning ? LocalizedStr("Stop") : LocalizedStr("Start"), for: .normal)
        scanLabel.text = isScanning ? LocalizedStr("Stop") : LocalizedStr("Start")

        if isScanning {
            resetAnimation()
            showPulse()
        } else {
            finish()
        }
    }
    
    @objc private func scanButtonTapped() {
        guard scanEnableBlc != nil else {
            return
        }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        scanEnableBlc!(isScanning)
    }
    
    private func showPulse() {
        guard pulseLayer.superlayer == nil else { return }

        pulseView.layer.addSublayer(pulseLayer)
        self.insertSubview(pulseView, belowSubview: progressView)
        pulseView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        
        let pulseRadius: CGFloat = width
        let pulseFrame = CGRect(x: 0, y: 0, width: pulseRadius, height: pulseRadius)
        
        // 设置 layer 的位置为中心
        pulseLayer.frame = pulseFrame
        pulseLayer.path = UIBezierPath(ovalIn: pulseLayer.bounds).cgPath
        pulseLayer.fillColor = UIColor.colorFromHexString(hexString: "#A0C4FF").cgColor
        pulseLayer.opacity = 0.0
        pulseLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pulseLayer.position = CGPoint(x: pulseView.bounds.width / 2, y: pulseView.bounds.height / 2)

        // 动画
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 2.0

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0.6
        opacity.toValue = 0.0

        let group = CAAnimationGroup()
        group.animations = [scale, opacity]
        group.duration = 1.25
        group.repeatCount = .infinity
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        group.isRemovedOnCompletion = false

        pulseLayer.add(group, forKey: "pulse")
    }

    private func hidePulse() {
        pulseLayer.removeAllAnimations()
        pulseLayer.removeFromSuperlayer()
        pulseLayer = CAShapeLayer()
    }
    
    private func applyRadialGradient(to view: UIView, centerColor: UIColor, radius: CGFloat) {
        let size = CGSize(width: radius * 2, height: radius * 2)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let cgContext = context.cgContext
            let colors = [centerColor.cgColor,
                          centerColor.withAlphaComponent(0.0).cgColor] as CFArray
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0.0, 1.0])!
            
            let center = CGPoint(x: radius, y: radius)
            cgContext.drawRadialGradient(gradient,
                                         startCenter: center,
                                         startRadius: 0,
                                         endCenter: center,
                                         endRadius: radius,
                                         options: .drawsAfterEndLocation)
        }

        let gradientLayer = CALayer()
        gradientLayer.contents = image.cgImage
        gradientLayer.frame = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        gradientLayer.cornerRadius = radius
        gradientLayer.masksToBounds = true

//        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() } // 可选：清理已有 sublayer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
