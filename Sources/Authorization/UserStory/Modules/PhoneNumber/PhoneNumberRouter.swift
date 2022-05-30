//
//  PhoneNumberRouter.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhoneNumberRouterInput: AnyObject {
    func openCodeConfirmationModule(output: CodeConfirmationModuleOutput)
    func openAccountCreation()
}

final class PhoneNumberRouter {
    weak var transitionHandler: UIViewController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension PhoneNumberRouter: PhoneNumberRouterInput {
    func openCodeConfirmationModule(output: CodeConfirmationModuleOutput) {
        let module = routeMap.codeConfirmationModule(output: output)
        transitionHandler?.present(module.view, animated: true)
    }
    
    func openAccountCreation() {
        let module = routeMap.createProfileModule()
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
}
