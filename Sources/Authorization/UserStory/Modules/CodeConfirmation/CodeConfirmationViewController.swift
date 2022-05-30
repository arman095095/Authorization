//
//  CodeConfirmationViewController.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem

protocol CodeConfirmationViewInput: AnyObject {
    func setupInitialState(stringFactory: CodeConfirmationStringFactoryProtocol)
    func setLoading(on: Bool)
}

final class CodeConfirmationViewController: UIViewController {
    var output: CodeConfirmationViewOutput?
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let codeTextField = UITextField()
    private let confirmButton = ButtonsFactory.blackLoadButton
    private var stackView: UIStackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidload()
    }
}

extension CodeConfirmationViewController: CodeConfirmationViewInput {
    func setupInitialState(stringFactory: CodeConfirmationStringFactoryProtocol) {
        setupViews(stringFactory: stringFactory)
        setupConstraints()
        setupActions()
    }
    
    func setLoading(on: Bool) {
        DispatchQueue.main.async {
            on ? self.confirmButton.loading() : self.confirmButton.stop()
        }
    }
}

private extension CodeConfirmationViewController {
    func setupViews(stringFactory: CodeConfirmationStringFactoryProtocol) {
        view.backgroundColor = .white
        titleLabel.text = stringFactory.confirmTitle
        view.backgroundColor = .systemGray6
        titleLabel.font = UIFont.avenir26()
        titleLabel.textAlignment = .center
        subtitleLabel.text = stringFactory.confirmSubtitle
        confirmButton.setTitle(stringFactory.confirmButtonTitle, for: .normal)
        let codeView = UIView(textField: codeTextField, label: subtitleLabel, spacing: 12)
        codeTextField.delegate = self
        codeTextField.keyboardType = .numberPad
        stackView = UIStackView(arrangedSubviews: [titleLabel, codeView, confirmButton], spacing: 25, axis: .vertical)
        guard let stackView = stackView else { return }
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        stackView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
    
    func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }
    
    @objc func confirmTapped() {
        output?.confirmAction(with: codeTextField.text)
    }
}

extension CodeConfirmationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        range.location < Constants.codeLenth
    }
}
