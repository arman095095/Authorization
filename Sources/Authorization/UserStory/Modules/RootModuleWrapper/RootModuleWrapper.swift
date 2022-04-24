//
//  File.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//

import Foundation
import UIKit
import Module

public protocol AuthorizationModuleInput: AnyObject {
    
}

public protocol AuthorizationModuleOutput: AnyObject {
    func userRegistered()
    func userAuthorized()
    func userNotExist()
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

extension RootModuleWrapper: EmailRegistrationModuleOutput {
    func userRegistered() {
        output?.userRegistered()
    }
}

extension RootModuleWrapper: LoginEntranceModuleOutput {
    func userAuthorized() {
        output?.userAuthorized()
    }
    
    func userNotExist() {
        output?.userNotExist()
    }
}

extension RootModuleWrapper: MainAuthModuleOutput { }
