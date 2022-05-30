//
//  CodeConfirmationRouter.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CodeConfirmationRouterInput: AnyObject {
    func dismissModule()
}

final class CodeConfirmationRouter {
    weak var transitionHandler: UIViewController?
}

extension CodeConfirmationRouter: CodeConfirmationRouterInput {
    func dismissModule() {
        transitionHandler?.dismiss(animated: true)
    }
}
