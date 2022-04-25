//
//  MainAuthRouter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module

protocol MainAuthRouterInput: AnyObject {
    func openLoginEntrance()
    func openEmailRegistration()
}

final class MainAuthRouter {
    weak var transitionHandler: UIViewController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension MainAuthRouter: MainAuthRouterInput {
    func openLoginEntrance() {
        let module = routeMap.loginEntranceModule()
        self.push(module.view)
    }
    
    func openEmailRegistration() {
        let module = routeMap.emailRegistrationModule()
        self.push(module.view)
    }
}

private extension MainAuthRouter {
    func push(_ view: UIViewController) {
        let transition = PushTransition()
        transition.source = transitionHandler
        transition.destination = view
        transition.perform(nil)
    }
}
