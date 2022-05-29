//
//  PhoneNumberAssembly.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import AlertManager

typealias PhoneNumberModule = Module<PhoneNumberModuleInput, PhoneNumberModuleOutput>

enum PhoneNumberAssembly {
    static func makeModule(alertManager: AlertManagerProtocol,
                           authManager: AuthManagerProtocol,
                           routeMap: RouteMapPrivate) -> PhoneNumberModule {
        let view = PhoneNumberViewController()
        let router = PhoneNumberRouter(routeMap: routeMap)
        let interactor = PhoneNumberInteractor(authManager: authManager)
        let stringFactory = AuthorizationStringFactory()
        let presenter = PhoneNumberPresenter(router: router,
                                             interactor: interactor,
                                             stringFactory: stringFactory,
                                             alertManager: alertManager)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return PhoneNumberModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
