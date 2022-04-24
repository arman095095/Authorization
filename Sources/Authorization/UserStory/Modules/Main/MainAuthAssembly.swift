//
//  MainAuthAssembly.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module

typealias MainAuthModule = Module<MainAuthModuleInput, MainAuthModuleOutput>

enum MainAuthAssembly {
    static func makeModule(routeMap: RouteMapPrivate) -> MainAuthModule {
        let view = MainAuthViewController()
        let router = MainAuthRouter(routeMap: routeMap)
        let interactor = MainAuthInteractor()
        let stringFactory = AuthorizationStringFactory()
        let presenter = MainAuthPresenter(router: router,
                                          interactor: interactor,
                                          stringFactory: stringFactory)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return MainAuthModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
