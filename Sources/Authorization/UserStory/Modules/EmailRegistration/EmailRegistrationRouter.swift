//
//  EmailRegistrationRouter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol EmailRegistrationRouterInput: AnyObject {
    
}

final class EmailRegistrationRouter {
    weak var transitionHandler: UIViewController?
}

extension EmailRegistrationRouter: EmailRegistrationRouterInput {
    
}
