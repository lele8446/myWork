//
//  CJAlertController.swift
//  CJClean
//
//  Created by lele8446 on 2025/8/18.
//

import Foundation
import UIKit

class CJAlertAction {
    let title: String
    let titleColor: UIColor?
    let font: UIFont?
    let handler: (() -> Void)?
    init(title: String, titleColor: UIColor?, font: UIFont?, handler: (() -> Void)?) {
        self.title = title
        self.titleColor = titleColor
        self.font = font
        self.handler = handler
    }
}

class CJAlertController: UIViewController {
    private let alertTitle: String?
    private let message: String?
    private var actions: [CJAlertAction] = []
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let stackView = UIStackView()
    
    init(alertTitle: String?, message: String?) {
        self.alertTitle = alertTitle
        self.message = message
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func addAction(_ acction: CJAlertAction) {
        actions.append(acction)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.clear
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 270),
//            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
//            containerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
        ])
        
        titleLabel.text = alertTitle
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
        
        setupActions()
    }
    
    private func setupActions() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if actions.count == 2 {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 8
            horizontalStack.distribution = .fillEqually
            horizontalStack.translatesAutoresizingMaskIntoConstraints = false
            for item in actions {
                let button = createBUtton(for: item)
                horizontalStack.addArrangedSubview(button)
            }
            stackView.addArrangedSubview(horizontalStack)
        } else {
            for item in actions {
                let button = createBUtton(for: item)
                stackView.addArrangedSubview(button)
            }
        }
    }
    
    private func createBUtton(for action: CJAlertAction) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(action.title, for: .normal)
        button.setTitleColor(action.titleColor ?? .systemBlue, for: .normal)
        button.titleLabel?.font = action.font ?? UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.65)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTargetClosure { [weak self] _ in
            self?.dismiss(animated: true) {
                action.handler?()
            }
        }
        return button
    }
}

typealias UIButtonTargetClosure = (UIButton) -> ()
private var handleKey: UInt8 = 0
extension UIButton {
    private class ClosureWrapper: NSObject {
        let closure: UIButtonTargetClosure
        init(_ closure: @escaping UIButtonTargetClosure) {
            self.closure = closure
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        objc_setAssociatedObject(self, &handleKey, ClosureWrapper(closure), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(closureAction), for: .touchUpInside)
    }
    @objc private func closureAction() {
        if let wrapper = objc_getAssociatedObject(self, &handleKey) as? ClosureWrapper {
            wrapper.closure(self)
        }
    }
}
