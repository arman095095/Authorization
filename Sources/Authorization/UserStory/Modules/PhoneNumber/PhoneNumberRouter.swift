//
//  PhoneNumberRouter.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhoneNumberRouterInput: AnyObject {
    func openCodeConfirmationModule()
}

final class PhoneNumberRouter {
    weak var transitionHandler: UIViewController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension PhoneNumberRouter: PhoneNumberRouterInput {
    func openCodeConfirmationModule() {
        let module = routeMap.codeConfirmationModule()
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
}
