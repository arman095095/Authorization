//
//  CodeConfirmationPresenter.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CodeConfirmationModuleOutput: AnyObject {
    
}

protocol CodeConfirmationModuleInput: AnyObject {
    
}

protocol CodeConfirmationViewOutput: AnyObject {
    
}

final class CodeConfirmationPresenter {
    
    weak var view: CodeConfirmationViewInput?
    weak var output: CodeConfirmationModuleOutput?
    private let router: CodeConfirmationRouterInput
    private let interactor: CodeConfirmationInteractorInput
    
    init(router: CodeConfirmationRouterInput,
         interactor: CodeConfirmationInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension CodeConfirmationPresenter: CodeConfirmationViewOutput {
    
}

extension CodeConfirmationPresenter: CodeConfirmationInteractorOutput {
    
}

extension CodeConfirmationPresenter: CodeConfirmationModuleInput {
    
}
