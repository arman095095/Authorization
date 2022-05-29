//
//  CodeConfirmationAssembly.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module

typealias CodeConfirmationModule = Module<CodeConfirmationModuleInput, CodeConfirmationModuleOutput>

enum CodeConfirmationAssembly {
    static func makeModule() -> CodeConfirmationModule {
        let view = CodeConfirmationViewController()
        let router = CodeConfirmationRouter()
        let interactor = CodeConfirmationInteractor()
        let presenter = CodeConfirmationPresenter(router: router, interactor: interactor)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return CodeConfirmationModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
