//
//  LoginEntranceRouter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginEntranceRouterInput: AnyObject {
    func showRemovedAttention()
}

protocol LoginEntranceRouterOutput: AnyObject {
    func acceptToRecover()
    func denyToRecover()
}

final class LoginEntranceRouter {
    weak var transitionHandler: UIViewController?
    weak var output: LoginEntranceRouterOutput?
}

extension LoginEntranceRouter: LoginEntranceRouterInput {

    func showRemovedAttention() {
        DispatchQueue.main.async {
            self.transitionHandler?.showAlertForRecover(acceptHandler: {
                self.output?.acceptToRecover()
            }, denyHandler: {
                self.output?.denyToRecover()
            })
        }
    }
}
