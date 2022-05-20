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
                  let accountService = r.resolve(AccountServiceProtocol.self),
                  let remoteStorage = r.resolve(ProfileRemoteStorageServiceProtocol.self),
                  let quickAccessManager = r.resolve(QuickAccessManagerProtocol.self),
                  let accountInfoService = r.resolve(AccountInfoNetworkServiceProtocol.self),
                  let profileService = r.resolve(ProfilesServiceProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return AuthManager(authService: authService,
                               accountService: accountService,
                               remoteStorage: remoteStorage,
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
