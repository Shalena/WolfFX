//
//  Validation.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

enum Alert {
    case success
    case failure
    case error
}

enum Valid: Equatable {
    case success
    case failure(Alert, AlertMessages)
}

enum FieldsValidationType {
    case firstName
    case email
    case password
   
    var regEx: String {
        switch self {
        case .firstName:
            return "[a-zA-Z0-9]"
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .password:
            return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,16}$"
        }
    }
}

enum CheckboxesValidationType {
    case termsSelected
}

enum AlertMessages: String {
    case firstNameInvalid = "First name should not contain punctuation characters"
    case firstNameEpmty = "First name should not be empty"
    case emailInvalid = "Email should be valid"
    case emailEmpty = "Email should not be empty"
    case passwordInvalid = "Password length should include from 8 to 16 characters. At least one letter and number"
    case passwordEmpty = "Password should not be empty"
    case checkbox = "Please accept out terms of use and privacy policy"
   
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

class Validation: NSObject {
    
    func validate(fields: (type: FieldsValidationType, inputValue: String)...) -> Valid {
        for valueToBeChecked in fields {
            switch valueToBeChecked.type {
        
            case .firstName:
                if let tempValue = isValidString((valueToBeChecked.inputValue, valueToBeChecked.type.regEx , .firstNameEpmty, .firstNameInvalid)) {
                    return tempValue
                }
            case .email:
                if let tempValue = isValidString((valueToBeChecked.inputValue, valueToBeChecked.type.regEx, .emailEmpty, .emailInvalid)) {
                    return tempValue
                }
            case .password:
                if let tempValue = isValidString((valueToBeChecked.inputValue, valueToBeChecked.type.regEx, .passwordEmpty, .passwordInvalid)) {
                    return tempValue
                }
        }
    }
        return .success
}
    func validate(type: FieldsValidationType, inputValue: String) -> Valid {
            switch type {
                
            case .firstName:
                if let tempValue = isValidString((inputValue, type.regEx, .firstNameEpmty, .firstNameInvalid)) {
                    return tempValue
                }
          
            case .email:
                if let tempValue = isValidString((inputValue, type.regEx, .emailEmpty, .emailInvalid)) {
                    return tempValue
                }
            case .password:
                if let tempValue = isValidString((inputValue, type.regEx, .passwordEmpty, .passwordInvalid)) {
                    return tempValue
                }
            }
        return .success
    }
    
    func isValidString(_ input: (text: String, regex: String, emptyAlert: AlertMessages, invalidAlert: AlertMessages)) -> Valid? {
        if input.text.isEmpty {
            return .failure(.error, input.emptyAlert)
        } else if isValidRegEx(input.text, input.regex) != true {
            return .failure(.error, input.invalidAlert)
        }
        return nil
    }
    
    func isValidRegEx(_ testStr: String, _ regex: String) -> Bool {
        let stringTest = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
    
    func validate(checkboxes: (type: CheckboxesValidationType, inputValue: Bool)...) -> Valid {
        for valueToBeChecked in checkboxes {
            if !valueToBeChecked.inputValue {
                return .failure(.error, AlertMessages.checkbox)
            }
        }
         return .success
    }
}
