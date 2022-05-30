//
//  EmailRegistrationRouter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol EmailRegistrationRouterInput: AnyObject {
    func openAccountCreation(userID: String)
}

final class EmailRegistrationRouter {
    weak var transitionHandler: UIViewController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension EmailRegistrationRouter: EmailRegistrationRouterInput {
    func openAccountCreation(userID: String) {
        let module = routeMap.createProfileModule(userID: userID)
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
}
