//
//  CodeConfirmationInteractor.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import ModelInterfaces

protocol CodeConfirmationInteractorInput: AnyObject {
    func sendCode(_ code: String, verifyID: String)
}

protocol CodeConfirmationInteractorOutput: AnyObject {
    func successAuthorized(account: AccountModelProtocol)
    func failureAuthorized(message: String)
    func responsedEmptyProfile()
}

final class CodeConfirmationInteractor {
    
    weak var output: CodeConfirmationInteractorOutput?
    private let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
}

extension CodeConfirmationInteractor: CodeConfirmationInteractorInput {
    func sendCode(_ code: String, verifyID: String) {
        authManager.codeConfirmation(verifyID: verifyID, code: code) { [weak self] result in
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
}
