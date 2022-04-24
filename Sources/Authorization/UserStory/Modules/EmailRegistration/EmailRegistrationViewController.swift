//
//  EmailRegistrationViewController.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem

protocol EmailRegistrationViewInput: AnyObject {
    func setLoading(on: Bool)
    func setupInitialState(stringFactory: EmailRegistrationStringFactoryProtocol)
}

final class EmailRegistrationViewController: UIViewController {
    var output: EmailRegistrationViewOutput?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var signUpStack = UIStackView()
    private let helloLabel = UILabel()
    private let signUpButton = LoadButton(backgroundColor: .buttonDark(),
                                          titleColor: .white,
                                          height: Constants.largeButtonHeight,
                                          activityColor: .white)
    private let emailTextField = UITextField()
    private let emailLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordLabel = UILabel()
    private let confirmPasswordTextField = UITextField()
    private let confirmPasswordLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

extension EmailRegistrationViewController: EmailRegistrationViewInput {
    func setLoading(on: Bool) {
        DispatchQueue.main.async {
            on ? self.signUpButton.loading() : self.signUpButton.stop()
        }
    }
    
    func setupInitialState(stringFactory: EmailRegistrationStringFactoryProtocol) {
        setupScrollView()
        setupViews(stringFactory: stringFactory)
        setupActions()
        addKeyboardObservers()
        addGesture()
    }
}

private extension EmailRegistrationViewController {
    
    func setupViews(stringFactory: EmailRegistrationStringFactoryProtocol) {
        helloLabel.font = UIFont.avenir26()
        helloLabel.text = stringFactory.greatingTitle
        signUpButton.setTitle(stringFactory.registrationTitle)
        emailLabel.text = stringFactory.emailTitle
        passwordLabel.text = stringFactory.passwordTitle
        confirmPasswordLabel.text = stringFactory.passwordConfirmationTitle
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        contentView.backgroundColor = .white
        scrollView.backgroundColor = .white
        helloLabel.textAlignment = .center
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let emailView = UIView(textField: emailTextField, label: emailLabel, spacing: 12)
        let passwordView = UIView(textField: passwordTextField, label: passwordLabel, spacing: 12)
        let confirmPasswordView = UIView(textField: confirmPasswordTextField, label: confirmPasswordLabel, spacing: 12)
        signUpStack = UIStackView(arrangedSubviews: [helloLabel,emailView,passwordView,confirmPasswordView,signUpButton], spacing: 25, axis: .vertical)
        
        self.contentView.addSubview(signUpStack)
        
        signUpStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 20).isActive = true
        signUpStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signUpStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        signUpStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        signUpStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true
    }
    
    @objc func registerTapped() {
        output?.register(email: emailTextField.text,
                         password: passwordTextField.text,
                         confirmPassword: confirmPasswordTextField.text)
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
            let offset = signUpStack.frame.minY + helloLabel.frame.maxY
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
        signUpButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
}
