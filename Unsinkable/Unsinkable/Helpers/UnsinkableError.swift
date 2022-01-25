//
//  UnsinkableError.swift
//  Unsinkable
//
//  Created by Thomas on 24/01/2022.
//

import Foundation

enum UnsinkableError {
    enum Network {
        
    }
    
    enum ProjectCreation {
        static let setProjectTitle = "You need to have at least a project title"
        static let setTaskTitle = "You need at least a title"
    }
}
