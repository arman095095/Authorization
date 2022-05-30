//
//  PhoneNumberRouter.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhoneNumberRouterInput: AnyObject {
    func openCodeConfirmationModule(output: CodeConfirmationModuleOutput, context: InputFlowContext)
    func openAccountCreation(userID: String)
}

final class PhoneNumberRouter {
    weak var transitionHandler: UIViewController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension PhoneNumberRouter: PhoneNumberRouterInput {
    func openCodeConfirmationModule(output: CodeConfirmationModuleOutput, context: InputFlowContext) {
        let module = routeMap.codeConfirmationModule(output: output, context: context)
        transitionHandler?.present(module.view, animated: true)
    }
    
    func openAccountCreation(userID: String) {
        let module = routeMap.createProfileModule(userID: userID)
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
}
