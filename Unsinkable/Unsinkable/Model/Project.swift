//
//  Project.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation
import UIKit

struct ProjectSource {
    var project: [Project]
}

struct Project {
    var title: String?
    var description: String?
    var members: [String]?
    var location: String?
    var date: String?
    var cover: UIImage?
    var task: [Task]
}

struct Task {
    var title: String?
    var description: String?
    var assignedTo: String?
}
