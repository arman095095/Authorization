//
//  CodeConfirmationInteractor.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CodeConfirmationInteractorInput: AnyObject {
    
}

protocol CodeConfirmationInteractorOutput: AnyObject {
    
}

final class CodeConfirmationInteractor {
    
    weak var output: CodeConfirmationInteractorOutput?
}

extension CodeConfirmationInteractor: CodeConfirmationInteractorInput {
    
}
