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
import Managers

public final class AuthorizationUserStoryAssembly {
    public static func assemble(container: Container) {
        AuthManagerAssembly.assemble(container: container)
        container.register(CredentionalValidatorProtocol.self) { r in
            CredentionalValidator()
        }
    }
}
