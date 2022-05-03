//
//  MainAuthViewController.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem

protocol MainAuthViewInput: AnyObject {
    func setupInitialState(stringFactory: MainStringFactoryProtocol)
}

final class MainAuthViewController: UIViewController {
    var output: MainAuthViewOutput?
    private let emailLabel = UILabel()
    private let loginLabel = UILabel()
    private let emailButton = ButtonsFactory.blackDefaultButton
    private let loginButton = ButtonsFactory.whiteDefaultButton
    private let logo = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

extension MainAuthViewController: MainAuthViewInput {
    func setupInitialState(stringFactory: MainStringFactoryProtocol) {
        setupViews(stringFactory: stringFactory)
        setupActions()
    }
}

//MARK: Setup UI
private extension MainAuthViewController {
    
    func setupViews(stringFactory: MainStringFactoryProtocol) {
        emailLabel.text = stringFactory.registrationTitle
        loginLabel.text = stringFactory.alreadyRegisteredTitle
        emailButton.setTitle(stringFactory.emailTitle, for: .normal)
        loginButton.setTitle(stringFactory.loginTitle, for: .normal)
        logo.image = UIImage(named: stringFactory.logoImageName)
        self.view.backgroundColor = .white
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        let emailView = UIView(button: emailButton , label: emailLabel, spacing: 20)
        let loginView = UIView(button: loginButton, label: loginLabel, spacing: 20)
        let authStackView = UIStackView(arrangedSubviews: [logo, emailView, loginView],
                                        spacing: 40,
                                        axis: .vertical)
        view.addSubview(authStackView)
        authStackView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor,constant: 15).isActive = true
        authStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor,constant: -15).isActive = true
        authStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        authStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        authStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        authStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
    }
    
    func setupActions() {
        emailButton.addTarget(self, action: #selector(emailTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    @objc private func emailTapped() {
        output?.emailRegistration()
    }
    
    @objc private func loginTapped() {
        output?.login()
    }
}
