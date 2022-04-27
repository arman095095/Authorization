//
//  LoginEntranceRouter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginEntranceRouterInput: AnyObject {
    func openAccountCreation()
}

final class LoginEntranceRouter {
    weak var transitionHandler: UIViewController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension LoginEntranceRouter: LoginEntranceRouterInput {

    func openAccountCreation() {
        let module = routeMap.createProfileModule()
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
}
