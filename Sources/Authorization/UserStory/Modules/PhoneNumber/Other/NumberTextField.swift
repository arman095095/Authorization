//
//  File.swift
//  
//
//  Created by Арман Чархчян on 29.05.2022.
//

import PhoneNumberKit

final class NumberTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "RU"
        }
        set {}
    }
}
