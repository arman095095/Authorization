//
//  LoginEntranceAssembly.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import Utils
import AlertManager

typealias LoginEntranceModule = Module<LoginEntranceModuleInput, LoginEntranceModuleOutput>

enum LoginEntranceAssembly {
    static func makeModule(credentionalValidator: CredentionalValidatorProtocol,
                           authManager: AuthManagerProtocol,
                           alertManager: AlertManagerProtocol,
                           routeMap: RouteMapPrivate) -> LoginEntranceModule {
        let view = LoginEntranceViewController()
        let router = LoginEntranceRouter(routeMap: routeMap)
        let interactor = LoginEntranceInteractor(validator: credentionalValidator,
                                                 authManager: authManager)
        let stringFactory = AuthorizationStringFactory()
        let presenter = LoginEntrancePresenter(router: router,
                                               interactor: interactor,
                                               alertManager: alertManager,
                                               stringFactory: stringFactory)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return LoginEntranceModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
