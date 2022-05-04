//
//  LoginEntranceInteractor.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import Utils
import ModelInterfaces

protocol LoginEntranceInteractorInput: AnyObject {
    func requestLogin(email: String, password: String)
    func validate(email: String?, password: String?)
}

protocol LoginEntranceInteractorOutput: AnyObject {
    func successAuthorized(account: AccountModelProtocol)
    func failureAuthorized(message: String)
    func responsedEmptyProfile()
    func successValidated(email: String, password: String)
    func failureValidated(message: String)
}

final class LoginEntranceInteractor {
    
    weak var output: LoginEntranceInteractorOutput?
    private let validator: CredentionalValidatorProtocol
    private let authManager: AuthManagerProtocol
    
    init(validator: CredentionalValidatorProtocol,
         authManager: AuthManagerProtocol) {
        self.validator = validator
        self.authManager = authManager
    }
}

extension LoginEntranceInteractor: LoginEntranceInteractorInput {

    func requestLogin(email: String, password: String) {
        authManager.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let account):
                self?.output?.successAuthorized(account: account)
            case .failure(let error):
                switch error {
                case .another(error: let error):
                    self?.output?.failureAuthorized(message: error.localizedDescription)
                case .profile(value: let value):
                    switch value {
                    case .emptyProfile:
                        self?.output?.responsedEmptyProfile()
                    }
                }
            }
        }
    }
    
    func validate(email: String?, password: String?) {
        guard let email = email,
              let password = password else {
            output?.failureValidated(message: ValidationError.Credentionals.notFilled.localizedDescription)
            return
        }
        guard validator.checkEmptyLogin(email: email, password: password) else {
            output?.failureValidated(message: ValidationError.Credentionals.notFilled.localizedDescription)
            return
        }
        guard validator.mailCorrectFormat(email) else {
            output?.failureValidated(message: ValidationError.Credentionals.invalidEmail.localizedDescription)
            return
        }
        output?.successValidated(email: email, password: password)
    }
}
