//
//  PhoneNumberPresenter.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AlertManager
import ModelInterfaces

protocol PhoneNumberModuleOutput: AnyObject {
    func userAuthorized(account: AccountModelProtocol)
}

protocol PhoneNumberModuleInput: AnyObject {
    
}

protocol PhoneNumberViewOutput: AnyObject {
    func viewDidLoad()
    func sendCode(for number: String?)
}

final class PhoneNumberPresenter {
    
    weak var view: PhoneNumberViewInput?
    weak var output: PhoneNumberModuleOutput?
    private let router: PhoneNumberRouterInput
    private let interactor: PhoneNumberInteractorInput
    private let stringFactory: PhoneNumberStringFactoryProtocol
    private let alertManager: AlertManagerProtocol
    
    init(router: PhoneNumberRouterInput,
         interactor: PhoneNumberInteractorInput,
         stringFactory: PhoneNumberStringFactoryProtocol,
         alertManager: AlertManagerProtocol) {
        self.router = router
        self.interactor = interactor
        self.stringFactory = stringFactory
        self.alertManager = alertManager
    }
}

extension PhoneNumberPresenter: PhoneNumberViewOutput {
    func viewDidLoad() {
        view?.setupInitialState(stringFactory: stringFactory)
    }
    
    func sendCode(for number: String?) {
        guard let number = number else {
            alertManager.present(type: .error, title: stringFactory.emptyNumberMessage)
            return
        }
        view?.setLoad(on: true)
        interactor.verify(for: number)
    }
}

extension PhoneNumberPresenter: PhoneNumberInteractorOutput {
    func successVerified(verifyID: String) {
        view?.setLoad(on: false)
        let context = InputFlowContext.phone(verifyID: verifyID)
        router.openCodeConfirmationModule(output: self, context: context)
    }
    
    func failureVerify(message: String) {
        view?.setLoad(on: false)
        alertManager.present(type: .error, title: message)
    }
}

extension PhoneNumberPresenter: PhoneNumberModuleInput {
    
}
extension PhoneNumberPresenter: CodeConfirmationModuleOutput {
    func openAccountCreation() {
        router.openAccountCreation()
    }
    
    func userAuthorized(account: AccountModelProtocol) {
        alertManager.present(type: .success, title: stringFactory.successAuthorizedMessage)
        output?.userAuthorized(account: account)
    }
}
