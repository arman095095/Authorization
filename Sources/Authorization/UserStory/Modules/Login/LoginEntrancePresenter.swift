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

protocol LoginEntranceModuleOutput: AnyObject {
    func userAuthorized()
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

    func successAuthorized() {
        view?.setLoading(on: false)
        alertManager.present(type: .success, title: stringFactory.successAuthorizedMessage)
        output?.userAuthorized()
    }
    
    func responsedEmptyProfile() {
        view?.setLoading(on: false)
        router.openAccountCreation()
    }
    
    func successRecovered() {
        view?.setLoading(on: false)
        alertManager.present(type: .success, title: stringFactory.successRecoveredMessage)
        output?.userAuthorized()
    }
    
    func responsedProfileRemoved() {
        view?.setLoading(on: false)
        router.showRemovedAttention()
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

extension LoginEntrancePresenter: LoginEntranceRouterOutput {

    func acceptToRecover() {
        view?.setLoading(on: true)
        interactor.requestRecover()
    }
    
    func denyToRecover() {
        interactor.logout()
    }
}

extension LoginEntrancePresenter: LoginEntranceModuleInput {
    
}
