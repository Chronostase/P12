//
//  Constants.swift
//  Unsinkable
//
//  Created by Thomas on 18/02/2021.
//

import Foundation

enum Constants {
    enum LoginString {
        static let registerButton = "Register"
        static let  longinButton = "Login"
        static let signInButton = "Sign in"
        static let or = "or"
        static let appleLogin = "Login with Apple"
    }
    
    enum Error {
        static let passwordError = "Please make sure your password is at least 8 characters, contains a special character and a number."
        static let fillField = "Please fill in all fields."
        static let cantFormat = "We can't format fields please retry"
    }
}
