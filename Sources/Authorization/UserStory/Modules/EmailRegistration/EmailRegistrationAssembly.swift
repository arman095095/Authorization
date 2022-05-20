//
//  EmailRegistrationAssembly.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import Utils
import AlertManager

typealias EmailRegistrationModule = Module<EmailRegistrationModuleInput, EmailRegistrationModuleOutput>

enum EmailRegistrationAssembly {
    static func makeModule(authManager: AuthManagerProtocol,
                           alertManager: AlertManagerProtocol,
                           routeMap: RouteMapPrivate) -> EmailRegistrationModule {
        let view = EmailRegistrationViewController()
        let router = EmailRegistrationRouter(routeMap: routeMap)
        let validator = CredentionalValidator()
        let interactor = EmailRegistrationInteractor(authManager: authManager,
                                                     validator: validator)
        let stringFactory = AuthorizationStringFactory()
        let presenter = EmailRegistrationPresenter(router: router,
                                                   interactor: interactor,
                                                   alertManager: alertManager,
                                                   stringFactory: stringFactory)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return EmailRegistrationModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
