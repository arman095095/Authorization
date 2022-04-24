//
//  File.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//

import Foundation
import Module

typealias AuthorizationModule = Module<AuthorizationModuleInput, AuthorizationModuleOutput>

enum RootModuleWrapperAssembly {
    static func makeModule(routeMap: RouteMapPrivate) -> AuthorizationModule {
        let wrapper = RootModuleWrapper(routeMap: routeMap)
        return AuthorizationModule(input: wrapper, view: wrapper.view()) {
            wrapper.output = $0
        }
    }
}
