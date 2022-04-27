//
//  File.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//

import Foundation
import UIKit
import Module
import Account
import Managers

public protocol AuthorizationModuleInput: AnyObject {
    
}

public protocol AuthorizationModuleOutput: AnyObject {
    func userAuthorized(userID: String, account: AccountModelProtocol)
}

final class RootModuleWrapper {

    private let routeMap: RouteMapPrivate
    weak var output: AuthorizationModuleOutput?
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }

    func view() -> UIViewController {
        let module = routeMap.mainAuthModule()
        module.output = self
        return module.view
    }
}

extension RootModuleWrapper: AuthorizationModuleInput {
    
}

extension RootModuleWrapper: LoginEntranceModuleOutput,
                             AccountModuleOutput {
    func userSuccessAuthorized(userID: String, account: AccountModelProtocol) {
        output?.userAuthorized(userID: userID, account: account)
    }
}

extension RootModuleWrapper: MainAuthModuleOutput { }

extension RootModuleWrapper: EmailRegistrationModuleOutput { }
