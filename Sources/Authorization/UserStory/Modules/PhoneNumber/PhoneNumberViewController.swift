//
//  PhoneNumberViewController.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem
import PhoneNumberKit

protocol PhoneNumberViewInput: AnyObject {
    func setupInitialState(stringFactory: PhoneNumberStringFactoryProtocol)
    func setLoad(on: Bool)
}

final class PhoneNumberViewController: UIViewController {
    var output: PhoneNumberViewOutput?
    private let helloLabel = UILabel()
    private let phoneTextField = NumberTextField()
    private let numberLabel = UILabel()
    private let sendCodeButton = ButtonsFactory.blackLoadButton
    private var stackView: UIStackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

private extension PhoneNumberViewController {
    func setupViews(stringFactory: PhoneNumberStringFactoryProtocol) {
        view.backgroundColor = .white
        phoneTextField.withFlag = true
        phoneTextField.withPrefix = true
        phoneTextField.withExamplePlaceholder = true
        helloLabel.font = UIFont.avenir26()
        helloLabel.text = stringFactory.greatingTitle
        helloLabel.textAlignment = .center
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.text = stringFactory.phoneNumberLabelTitle
        sendCodeButton.setTitle(stringFactory.codeSendButtonTitle, for: .normal)
        let phoneNumberView = UIView(textField: phoneTextField, label: numberLabel, spacing: 12)
        stackView = UIStackView(arrangedSubviews: [helloLabel, phoneNumberView, sendCodeButton], spacing: 25, axis: .vertical)
        guard let stackView = stackView else { return }
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        stackView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stackView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }
    
    func setupActions() {
        sendCodeButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc func sendButtonTapped() {
        output?.sendCode(for: phoneTextField.phoneNumber?.numberString)
    }
}

extension PhoneNumberViewController: PhoneNumberViewInput {
    
    func setLoad(on: Bool) {
        DispatchQueue.main.async {
            on ? self.sendCodeButton.loading() : self.sendCodeButton.stop()
        }
    }
    
    func setupInitialState(stringFactory: PhoneNumberStringFactoryProtocol) {
        setupViews(stringFactory: stringFactory)
        setupConstraints()
        setupActions()
    }
}
