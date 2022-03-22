//
//  FakeCustomResponse.swift
//  Unsinkable
//
//  Created by Thomas on 06/05/2021.
//

import Foundation

struct FakeCustomResponse {
    var user: FakeUserDetails
}

struct FakeUserDetails{
    var email: String?
    var password: String?
    var firstName: String?
    var name: String?
    var userId: String?
    var projects: [FakeProject?]?
}

struct FakeProject {
    var title: String?
    var projectID: String?
    var description: String?
    var ownerUserId: String?
    var isPersonal: Bool?
    var downloadUrl: String?
    var taskList: [FakeTask?]?
}

struct FakeTask {
    var title: String?
    var projectID: String?
    var taskID: String?
    var priority: Bool?
    var deadLine: Date?
    var commentary: String?
    var location: String?
    var isValidate: Bool?
}

