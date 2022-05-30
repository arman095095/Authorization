//
//  CodeConfirmationPresenter.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AlertManager
import ModelInterfaces

struct CodeConfirmationConstants {
    static let codeLenth = 6
}

protocol CodeConfirmationModuleOutput: AnyObject {
    func openAccountCreation()
    func userAuthorized(account: AccountModelProtocol)
}

protocol CodeConfirmationModuleInput: AnyObject {
    
}

protocol CodeConfirmationViewOutput: AnyObject {
    func viewDidload()
    func confirmAction(with code: String?)
}

final class CodeConfirmationPresenter {
    
    weak var view: CodeConfirmationViewInput?
    weak var output: CodeConfirmationModuleOutput?
    private let router: CodeConfirmationRouterInput
    private let context: InputFlowContext
    private let stringFactory: CodeConfirmationStringFactoryProtocol
    private let alertManager: AlertManagerProtocol
    private let interactor: CodeConfirmationInteractorInput
    
    init(router: CodeConfirmationRouterInput,
         interactor: CodeConfirmationInteractorInput,
         stringFactory: CodeConfirmationStringFactoryProtocol,
         alertManager: AlertManagerProtocol,
         context: InputFlowContext) {
        self.router = router
        self.interactor = interactor
        self.stringFactory = stringFactory
        self.alertManager = alertManager
        self.context = context
    }
}

extension CodeConfirmationPresenter: CodeConfirmationViewOutput {
    func viewDidload() {
        view?.setupInitialState(stringFactory: stringFactory)
    }
    
    func confirmAction(with code: String?) {
        guard let code = code,
              code.count == CodeConfirmationConstants.codeLenth,
              let _ = Int(code) else {
            alertManager.present(type: .error, title: stringFactory.incorrectFormatCode)
            return
        }
        view?.setLoading(on: true)
        switch context {
        case .phone(verifyID: let verifyID):
            interactor.sendCode(code, verifyID: verifyID)
        }
    }
}

extension CodeConfirmationPresenter: CodeConfirmationInteractorOutput {
    func successAuthorized(account: AccountModelProtocol) {
        view?.setLoading(on: false)
        router.dismissModule()
        output?.userAuthorized(account: account)
    }
    
    func failureAuthorized(message: String) {
        view?.setLoading(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func responsedEmptyProfile() {
        view?.setLoading(on: false)
        router.dismissModule()
        output?.openAccountCreation()
    }
}

extension CodeConfirmationPresenter: CodeConfirmationModuleInput {
    
}
