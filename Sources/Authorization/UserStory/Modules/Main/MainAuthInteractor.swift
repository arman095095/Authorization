//
//  MainAuthInteractor.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MainAuthInteractorInput: AnyObject {
    
}

protocol MainAuthInteractorOutput: AnyObject {
    
}

final class MainAuthInteractor {
    
    weak var output: MainAuthInteractorOutput?
}

extension MainAuthInteractor: MainAuthInteractorInput {
    
}
