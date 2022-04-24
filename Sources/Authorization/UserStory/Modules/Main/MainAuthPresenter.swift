//
//  MainAuthPresenter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MainAuthModuleOutput: AnyObject {
    
}

protocol MainAuthModuleInput: AnyObject {
    
}

protocol MainAuthViewOutput: AnyObject {
    func viewDidLoad()
    func login()
    func emailRegistration()
}

final class MainAuthPresenter {
    
    weak var view: MainAuthViewInput?
    weak var output: MainAuthModuleOutput?
    private let stringFactory: MainStringFactoryProtocol
    private let router: MainAuthRouterInput
    private let interactor: MainAuthInteractorInput
    
    init(router: MainAuthRouterInput,
         interactor: MainAuthInteractorInput,
         stringFactory: MainStringFactoryProtocol) {
        self.router = router
        self.interactor = interactor
        self.stringFactory = stringFactory
    }
}

extension MainAuthPresenter: MainAuthViewOutput {
    func viewDidLoad() {
        view?.setupInitialState(stringFactory: stringFactory)
    }
    
    func login() {
        router.openLoginEntrance()
    }
    
    func emailRegistration() {
        router.openEmailRegistration()
    }
}

extension MainAuthPresenter: MainAuthInteractorOutput {
    
}

extension MainAuthPresenter: MainAuthModuleInput {
    
}
