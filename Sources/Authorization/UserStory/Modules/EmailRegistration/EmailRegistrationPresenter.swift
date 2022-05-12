//
//  EmailRegistrationPresenter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AlertManager

protocol EmailRegistrationModuleOutput: AnyObject { }

protocol EmailRegistrationModuleInput: AnyObject { }

protocol EmailRegistrationViewOutput: AnyObject {
    func viewDidLoad()
    func register(email: String?,
                  password: String?,
                  confirmPassword: String?)
}

final class EmailRegistrationPresenter {
    
    weak var view: EmailRegistrationViewInput?
    weak var output: EmailRegistrationModuleOutput?
    private let router: EmailRegistrationRouterInput
    private let stringFactory: EmailRegistrationStringFactoryProtocol
    private let interactor: EmailRegistrationInteractorInput
    private let alertManager: AlertManagerProtocol
    
    init(router: EmailRegistrationRouterInput,
         interactor: EmailRegistrationInteractorInput,
         alertManager: AlertManagerProtocol,
         stringFactory: EmailRegistrationStringFactoryProtocol) {
        self.router = router
        self.interactor = interactor
        self.alertManager = alertManager
        self.stringFactory = stringFactory
    }
}

extension EmailRegistrationPresenter: EmailRegistrationViewOutput {
    func viewDidLoad() {
        view?.setupInitialState(stringFactory: stringFactory)
    }
    
    func register(email: String?,
                  password: String?,
                  confirmPassword: String?) {
        view?.setLoading(on: true)
        interactor.validate(email: email, password: password, confirm: confirmPassword)
    }
}

extension EmailRegistrationPresenter: EmailRegistrationInteractorOutput {
    func successValidated(email: String, password: String) {
        interactor.requestRegistration(email: email, password: password)
    }
    
    func failureValidated(message: String) {
        view?.setLoading(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func successRegistered() {
        view?.setLoading(on: false)
        alertManager.present(type: .success, title: stringFactory.successRegisteredMessage)
        router.openAccountCreation()
    }
    
    func failureRegistrationRequest(message: String) {
        view?.setLoading(on: false)
        alertManager.present(type: .error, title: message)
    }
}

extension EmailRegistrationPresenter: EmailRegistrationModuleInput {
    
}
