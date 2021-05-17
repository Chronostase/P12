//
//  CustomResponse.swift
//  Unsinkable
//
//  Created by Thomas on 06/05/2021.
//

import Foundation

struct CustomResponse {
    var user: UserDetails
}

struct UserDetails {
    var email: String?
    var password: String?
    var displayName: String?
    var userId: String?
}
