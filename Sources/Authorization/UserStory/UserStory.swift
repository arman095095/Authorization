//
//  AuthorizationUserStory.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//

import Foundation
import Swinject
import Module
import Utils
import AlertManager
import NetworkServices
import AuthorizationRouteMap
import AccountRouteMap
import UserStoryFacade

public final class AuthorizationUserStory {
    private let container: Container
    private var outputWrapper: RootModuleWrapper?
    public init(container: Container) {
        self.container = container
    }
}

extension AuthorizationUserStory: AuthorizationRouteMap {
    public func rootModule() -> AuthorizationModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension AuthorizationUserStory: RouteMapPrivate {

    func codeConfirmationModule() -> CodeConfirmationModule {
        
    }

    func phoneNumberEntranceModule() -> PhoneNumberModule {
        let safeResolver = container.synchronize()
        guard let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = PhoneNumberAssembly.makeModule(alertManager: alertManager,
                                                    authManager: authManager,
                                                    routeMap: self)
        module.output = outputWrapper
        return module
    }

    func createProfileModule() -> AccountModule {
        guard let module = container.synchronize().resolve(UserStoryFacadeProtocol.self)?.account?.createAccountModule() else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        module.output = outputWrapper
        return module
    }
    
    func loginEntranceModule() -> LoginEntranceModule {
        let safeResolver = container.synchronize()
        guard let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = LoginEntranceAssembly.makeModule(authManager: authManager,
                                                      alertManager: alertManager,
                                                      routeMap: self)
        module.output = outputWrapper
        return module
    }
    
    func emailRegistrationModule() -> EmailRegistrationModule {
        let safeResolver = container.synchronize()
        guard let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = EmailRegistrationAssembly.makeModule(authManager: authManager,
                                                          alertManager: alertManager,
                                                          routeMap: self)
        module.output = outputWrapper
        return module
    }
    
    func mainAuthModule() -> MainAuthModule {
        let module = MainAuthAssembly.makeModule(routeMap: self)
        module.output = outputWrapper
        return module
    }
}
