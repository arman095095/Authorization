//
//  LoginEntrancePresenter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import AlertManager
import ModelInterfaces

protocol LoginEntranceModuleOutput: AnyObject {
    func userSuccessAuthorized(account: AccountModelProtocol)
}

protocol LoginEntranceModuleInput: AnyObject {
    
}

protocol LoginEntranceViewOutput: AnyObject {
    func viewDidLoad()
    func login(with email: String?, password: String?)
}

final class LoginEntrancePresenter {
    
    weak var view: LoginEntranceViewInput?
    weak var output: LoginEntranceModuleOutput?
    private let router: LoginEntranceRouterInput
    private let interactor: LoginEntranceInteractorInput
    private let alertManager: AlertManagerProtocol
    private let stringFactory: LoginStringFactoryProtocol

    init(router: LoginEntranceRouterInput,
         interactor: LoginEntranceInteractorInput,
         alertManager: AlertManagerProtocol,
         stringFactory: LoginStringFactoryProtocol) {
        self.router = router
        self.interactor = interactor
        self.alertManager = alertManager
        self.stringFactory = stringFactory
    }
}

extension LoginEntrancePresenter: LoginEntranceViewOutput {

    func login(with email: String?, password: String?) {
        view?.setLoading(on: true)
        interactor.validate(email: email, password: password)
    }
    
    func viewDidLoad() {
        view?.setupInitialState(stringFactory: stringFactory)
    }
}

extension LoginEntrancePresenter: LoginEntranceInteractorOutput {

    func successAuthorized(account: AccountModelProtocol) {
        view?.setLoading(on: false)
        alertManager.present(type: .success, title: stringFactory.successAuthorizedMessage)
        output?.userSuccessAuthorized(account: account)
    }
    
    func responsedEmptyProfile() {
        view?.setLoading(on: false)
        router.openAccountCreation()
    }
    
    func failureAuthorized(message: String) {
        view?.setLoading(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func successValidated(email: String, password: String) {
        interactor.requestLogin(email: email, password: password)
    }
    
    func failureValidated(message: String) {
        view?.setLoading(on: false)
        alertManager.present(type: .error, title: message)
    }
}

extension LoginEntrancePresenter: LoginEntranceModuleInput {
    
}
