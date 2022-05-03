//
//  LoginEntranceViewController.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem

protocol LoginEntranceViewInput: AnyObject {
    func setupInitialState(stringFactory: LoginStringFactoryProtocol)
    func setLoading(on: Bool)
}

final class LoginEntranceViewController: UIViewController {
    var output: LoginEntranceViewOutput?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var loginStack = UIStackView()
    private let helloLabel = UILabel()
    private let loginButton = ButtonsFactory.blackLoadButton
    private let emailTextField = UITextField()
    private let emailLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

extension LoginEntranceViewController: LoginEntranceViewInput {
    func setLoading(on: Bool) {
        DispatchQueue.main.async {
            on ? self.loginButton.loading() : self.loginButton.stop()
        }
    }
    
    func setupInitialState(stringFactory: LoginStringFactoryProtocol) {
        setupScrollView()
        setupViews(stringFactory: stringFactory)
        setupActions()
        addKeyboardObservers()
        addGesture()
    }
}

private extension LoginEntranceViewController {
    
    func setupViews(stringFactory: LoginStringFactoryProtocol) {
        helloLabel.text = stringFactory.gladToSeeTitle
        loginButton.setTitle(stringFactory.loginTitle, for: .normal)
        emailLabel.text = stringFactory.emailTitle
        passwordLabel.text = stringFactory.passwordTitle
        helloLabel.font = UIFont.avenir26()
        passwordTextField.isSecureTextEntry = true
        view.backgroundColor = .white
        helloLabel.textAlignment = .center
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let emailView = UIView(textField: emailTextField, label: emailLabel, spacing: 12)
        let passwordView = UIView(textField: passwordTextField, label: passwordLabel, spacing: 12)
        
        loginStack = UIStackView(arrangedSubviews: [emailView,passwordView,loginButton], spacing: 15, axis: .vertical)
        
        self.contentView.addSubview(loginStack)
        self.contentView.addSubview(helloLabel)
        
        helloLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        helloLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor,constant: 20).isActive = true
        
        loginStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        loginStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true
        loginStack.topAnchor.constraint(greaterThanOrEqualTo: helloLabel.bottomAnchor, constant: 20).isActive = true
        loginStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loginStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    @objc func loginTapped() {
        loginButton.loading()
        output?.login(with: emailTextField.text, password: passwordTextField.text)
    }
    
    func addGesture() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        scrollView.contentSize = .zero
        if notification.name == UIResponder.keyboardWillShowNotification {
            let contentSize = view.safeAreaLayoutGuide.layoutFrame.height + keyboardHeight
            let offset = helloLabel.frame.maxY // исправить
            scrollView.contentOffset.y = offset
            scrollView.contentSize.height = contentSize
        }
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        scrollView.contentSize = .zero
    }
    
    func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
}
