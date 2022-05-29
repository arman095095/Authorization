//
//  CodeConfirmationViewController.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CodeConfirmationViewInput: AnyObject {
    
}

final class CodeConfirmationViewController: UIViewController {
    var output: CodeConfirmationViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension CodeConfirmationViewController: CodeConfirmationViewInput {
    
}
