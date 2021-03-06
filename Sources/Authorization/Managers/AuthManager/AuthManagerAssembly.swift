//
//  File.swift
//  
//
//  Created by Арман Чархчян on 22.04.2022.
//

import Swinject
import Foundation
import NetworkServices
import Managers

final class AuthManagerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(AuthManagerProtocol.self) { r in
            guard let authService = r.resolve(AuthNetworkServiceProtocol.self),
                  let quickAccessManager = r.resolve(QuickAccessManagerProtocol.self),
                  let accountInfoService = r.resolve(AccountContentNetworkServiceProtocol.self),
                  let profileService = r.resolve(ProfileInfoNetworkServiceProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return AuthManager(authService: authService,
                               quickAccessManager: quickAccessManager,
                               profileService: profileService,
                               accountInfoService: accountInfoService,
                               container: container)
        }.inObjectScope(.weak)
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
