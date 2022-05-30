//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//

import Foundation
import AccountRouteMap

protocol RouteMapPrivate: AnyObject {
    func loginEntranceModule() -> LoginEntranceModule
    func emailRegistrationModule() -> EmailRegistrationModule
    func mainAuthModule() -> MainAuthModule
    func phoneNumberEntranceModule() -> PhoneNumberModule
    func createProfileModule() -> AccountModule
    func codeConfirmationModule(output: CodeConfirmationModuleOutput) -> CodeConfirmationModule
}
