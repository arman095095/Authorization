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
import Managers
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

    func createProfileModule() -> AccountModule {
        guard let module = container.synchronize().resolve(UserStoryFacadeProtocol.self)?.accountUserStory?.createAccountModule() else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        module.output = outputWrapper
        return module
    }
    
    func loginEntranceModule() -> LoginEntranceModule {
        let safeResolver = container.synchronize()
        guard let credentionalValidator = safeResolver.resolve(CredentionalValidatorProtocol.self),
              let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = LoginEntranceAssembly.makeModule(credentionalValidator: credentionalValidator,
                                                      authManager: authManager,
                                                      alertManager: alertManager,
                                                      routeMap: self)
        module.output = outputWrapper
        return module
    }
    
    func emailRegistrationModule() -> EmailRegistrationModule {
        let safeResolver = container.synchronize()
        guard let credentionalValidator = safeResolver.resolve(CredentionalValidatorProtocol.self),
              let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = EmailRegistrationAssembly.makeModule(authManager: authManager,
                                                          credentionalValidator: credentionalValidator,
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

enum ErrorMessage: LocalizedError {
    case dependency
}
