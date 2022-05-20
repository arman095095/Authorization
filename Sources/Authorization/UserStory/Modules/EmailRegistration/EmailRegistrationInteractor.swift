//
//  EmailRegistrationInteractor.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Utils

protocol EmailRegistrationInteractorInput: AnyObject {
    func requestRegistration(email: String, password: String)
    func validate(email: String?,
                  password: String?,
                  confirm: String?)
}

protocol EmailRegistrationInteractorOutput: AnyObject {
    func successRegistered()
    func failureRegistrationRequest(message: String)
    func successValidated(email: String, password: String)
    func failureValidated(message: String)
}

final class EmailRegistrationInteractor {
    
    weak var output: EmailRegistrationInteractorOutput?
    private let authManager: AuthManagerProtocol
    private let validator: CredentionalValidatorProtocol
    
    init(authManager: AuthManagerProtocol,
         validator: CredentionalValidatorProtocol) {
        self.authManager = authManager
        self.validator = validator
    }
}

extension EmailRegistrationInteractor: EmailRegistrationInteractorInput {

    func validate(email: String?,
                  password: String?,
                  confirm: String?) {
        guard let email = email,
              let password = password,
              let confirmPassword = confirm else {
            output?.failureValidated(message: CredentionalValidator.Error.notFilled.localizedDescription)
            return
        }
        guard validator.checkEmptyRegistration(email: email,
                                               password: password,
                                               confirmPassword: confirmPassword) else {
            output?.failureValidated(message: CredentionalValidator.Error.notFilled.localizedDescription)
            return
        }
        guard validator.mailCorrectFormat(email) else {
            output?.failureValidated(message: CredentionalValidator.Error.invalidEmail.localizedDescription)
            return
        }
        guard validator.passwordsMatches(password: password,
                                         confirmed: confirmPassword) else {
            output?.failureValidated(message: CredentionalValidator.Error.passwordsNotMatched.localizedDescription)
            return
        }
        output?.successValidated(email: email, password: password)
    }
    
    func requestRegistration(email: String, password: String) {
        authManager.register(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successRegistered()
            case .failure(let error):
                self?.output?.failureRegistrationRequest(message: error.localizedDescription)
            }
        }
    }
}
