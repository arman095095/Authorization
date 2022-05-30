//
//  CodeConfirmationAssembly.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import AlertManager

typealias CodeConfirmationModule = Module<CodeConfirmationModuleInput, CodeConfirmationModuleOutput>

enum CodeConfirmationAssembly {
    static func makeModule(alertManager: AlertManagerProtocol,
                           authManager: AuthManagerProtocol) -> CodeConfirmationModule {
        let view = CodeConfirmationViewController()
        let router = CodeConfirmationRouter()
        let interactor = CodeConfirmationInteractor(authManager: authManager)
        let stringFactory = AuthorizationStringFactory()
        let presenter = CodeConfirmationPresenter(router: router,
                                                  interactor: interactor,
                                                  stringFactory: stringFactory,
                                                  alertManager: alertManager)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return CodeConfirmationModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
