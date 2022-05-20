//
//  File.swift
//  
//
//  Created by Арман Чархчян on 22.04.2022.
//

import Foundation
import Utils
import Swinject
import NetworkServices
import AlertManager
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import AuthorizationRouteMap
import UserStoryFacade

public final class AuthorizationUserStoryAssembly: Assembly {
    public init() { }
    public func assemble(container: Container) {
        AuthNetworkServiceAssembly().assemble(container: container)
        AuthManagerAssembly().assemble(container: container)
        container.register(AuthorizationRouteMap.self) { r in
            AuthorizationUserStory(container: container)
        }
    }
}
