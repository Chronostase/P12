//
//  Utilities.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import Foundation

class Regex {
    
    static func isPasswordValide(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@%#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func validateEmail(candidate: String) -> Bool {
     let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
}
