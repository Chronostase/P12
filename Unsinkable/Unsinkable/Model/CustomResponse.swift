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
    var firstName: String?
    var name: String? 
    var userId: String?
    var projects: [Project?]?
}
struct Project {
    var title: String?
    var projectID: String?
    var description: String?
    var ownerUserId: String?
    var isPersonal: Bool?
    var downloadUrl: String?
    var taskList: [Task?]?
}

struct Task {
    var title: String?
    var projectID: String?
    var taskID: String?
    var priority: Bool?
    var deadLine: String?
    var commentary: String? 
}
