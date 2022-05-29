//
//  AuthMessages.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//

import Foundation

protocol PhoneNumberStringFactoryProtocol {
    var greatingTitle: String { get }
    var codeSendButtonTitle: String { get }
    var phoneNumberLabelTitle: String { get }
    var emptyNumberMessage: String { get }
}

protocol MainStringFactoryProtocol {
    var phoneNumberTitle: String { get }
    var phoneNumberButtonTitle: String { get }
    var registrationTitle: String { get }
    var alreadyRegisteredTitle: String { get }
    var emailTitle: String { get }
    var loginTitle: String { get }
    var logoImageName: String { get }
}

protocol LoginStringFactoryProtocol {
    var successRecoveredMessage: String { get }
    var successAuthorizedMessage: String { get }
    var gladToSeeTitle: String { get }
    var loginTitle: String { get }
    var emailTitle: String { get }
    var passwordTitle: String { get }
}

protocol EmailRegistrationStringFactoryProtocol {
    var successRegisteredMessage: String { get }
    var greatingTitle: String { get }
    var registrationTitle: String { get }
    var emailTitle: String { get }
    var passwordTitle: String { get }
    var passwordConfirmationTitle: String { get }
}

struct AuthorizationStringFactory: EmailRegistrationStringFactoryProtocol,
                                   MainStringFactoryProtocol,
                                   LoginStringFactoryProtocol,
                                   PhoneNumberStringFactoryProtocol {
    var emptyNumberMessage: String = "Введите корректный номер телефона"
    var codeSendButtonTitle: String = "Получить код"
    var phoneNumberLabelTitle: String = "Номер телефона"
    let successAuthorizedMessage = "Вы успешно авторизовались"
    let successRegisteredMessage = "Вы успешно зарегистрировались"
    let successRecoveredMessage = "Профиль успешно восстановлен"
    let registrationTitle = "Зарегистрироваться"
    let alreadyRegisteredTitle = "Уже зарегистрировались?"
    let phoneNumberTitle = "По номеру телефона"
    let phoneNumberButtonTitle = "Phone"
    let emailTitle = "E-mail"
    let loginTitle = "Login"
    let logoImageName = "logotip"
    let gladToSeeTitle = "Мы рады Вас видеть!"
    let passwordTitle = "Пароль"
    let greatingTitle = "Добро пожаловать!"
    let passwordConfirmationTitle = "Подтверждение пароля"
}
