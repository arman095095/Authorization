//
//  File.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//

import Foundation
import UIKit
import Module
import ModelInterfaces
import AuthorizationRouteMap
import AccountRouteMap

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

    func userSuccessCreated(account: AccountModelProtocol) {
        output?.userAuthorized(account: account)
    }
    
    func userSuccessEdited() { }
    
    func userAuthorized(account: AccountModelProtocol) {
        output?.userAuthorized(account: account)
    }
}

extension RootModuleWrapper: MainAuthModuleOutput { }

extension RootModuleWrapper: EmailRegistrationModuleOutput { }

extension RootModuleWrapper: PhoneNumberModuleOutput { }
