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

protocol LoginEntranceInteractorInput: AnyObject {
    func requestLogin(email: String, password: String)
    func validate(email: String?, password: String?)
    func requestRecover()
    func logout()
}

protocol LoginEntranceInteractorOutput: AnyObject {
    func successAuthorized()
    func successRecovered()
    func failureAuthorized(message: String)
    func responsedEmptyProfile()
    func responsedProfileRemoved()
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
    
    func logout() {
        authManager.signOut()
    }

    func requestRecover() {
        authManager.recoverAccount { [weak self] result in
            switch result {
            case .success:
                self?.output?.successRecovered()
            case .failure(let error):
                self?.output?.failureAuthorized(message: error.localizedDescription)
            }
        }
    }

    func requestLogin(email: String, password: String) {
        authManager.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successAuthorized()
            case .failure(let error):
                switch error {
                case .another(error: let error):
                    self?.output?.failureAuthorized(message: error.localizedDescription)
                case .profile(value: let value):
                    switch value {
                    case .emptyProfile:
                        self?.output?.responsedEmptyProfile()
                    case .profileRemoved:
                        self?.output?.responsedProfileRemoved()
                    }
                default:
                    break
                }
            }
        }
    }
    
    func validate(email: String?, password: String?) {
        guard let email = email,
              let password = password else {
            output?.failureValidated(message: CredentionalValidator.Error.notFilled.localizedDescription)
            return
        }
        guard validator.checkEmptyLogin(email: email, password: password) else {
            output?.failureValidated(message: CredentionalValidator.Error.notFilled.localizedDescription)
            return
        }
        guard validator.mailCorrectFormat(email) else {
            output?.failureValidated(message: CredentionalValidator.Error.invalidEmail.localizedDescription)
            return
        }
        output?.successValidated(email: email, password: password)
    }
}
