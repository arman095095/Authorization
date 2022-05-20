//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation

protocol CredentionalValidatorProtocol {
    func checkEmptyRegistration(email: String,
                                password: String,
                                confirmPassword: String) -> Bool
    func checkEmptyLogin(email: String, password: String) -> Bool
    func mailCorrectFormat(_ email: String) -> Bool
    func passwordsMatches(password: String, confirmed: String) -> Bool
}

struct CredentionalValidator: CredentionalValidatorProtocol {
    
    enum Error: LocalizedError {
        case notFilled
        case invalidEmail
        case passwordsNotMatched
        
        public var errorDescription: String? {
            switch self {
            case .notFilled:
                return NSLocalizedString("Заполните все поля", comment: "")
            case .invalidEmail:
                return NSLocalizedString("Формат почты не является допустимым", comment: "")
            case .passwordsNotMatched:
                return NSLocalizedString("Пароли не совпадают", comment: "")
            }
        }
    }
    
     func checkEmptyRegistration(email: String, password: String, confirmPassword: String) -> Bool {
        return !(email == "" || password == "" || confirmPassword == "")
    }
    
     func checkEmptyLogin(email: String, password: String) -> Bool {
        return !(email == "" || password == "")
    }
    
     func mailCorrectFormat(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
     func passwordsMatches(password: String, confirmed: String) -> Bool {
        return password == confirmed
    }
}
