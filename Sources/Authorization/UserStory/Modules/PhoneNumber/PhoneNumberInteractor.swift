//
//  PhoneNumberInteractor.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhoneNumberInteractorInput: AnyObject {
    func verify(for number: String)
}

protocol PhoneNumberInteractorOutput: AnyObject {
    func successVerified()
    func failureVerify(message: String)
}

final class PhoneNumberInteractor {
    
    weak var output: PhoneNumberInteractorOutput?
    private let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
}

extension PhoneNumberInteractor: PhoneNumberInteractorInput {
    func verify(for number: String) {
        authManager.login(phoneNumber: number) { [weak self] result in
            switch result {
            case .success():
                self?.output?.successVerified()
            case .failure(let error):
                self?.output?.failureVerify(message: error.localizedDescription)
            }
        }
    }
}
