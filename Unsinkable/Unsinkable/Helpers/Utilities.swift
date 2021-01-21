//
//  Utilities.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import Foundation

class Utilities {
    
    static func isPasswordValide(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@%#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
