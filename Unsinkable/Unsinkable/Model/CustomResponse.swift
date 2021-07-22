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

struct UserDetails{
    var email: String?
    var password: String?
    var displayName: String?
    var firstName: String?
    var name: String? 
    var userId: String?
    var projects: [Project?]?
}

struct Project {
    var title: String?
    var description: String?
    var ownerUserId: String?
    var taskList: [Task?]?
}

struct Task {
    var title: String?
    var description: String?
}
