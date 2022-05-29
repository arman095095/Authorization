//
//  PhoneNumberRouter.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PhoneNumberRouterInput: AnyObject {

}

final class PhoneNumberRouter {
    weak var transitionHandler: UIViewController?
}

extension PhoneNumberRouter: PhoneNumberRouterInput {
    
}
