//
//  ProjectCreationPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation

protocol ProjectCreationPresenterDelegate: AnyObject {
    func fetchProjectSucceed() 
}

class ProjectCreationPresenter {
    weak var delegate: ProjectCreationPresenterDelegate?
    
    func checkTextFieldsAvailable(_ title: String?, _ description: String?) -> Bool {
        if title != "" && description != "" {
            return true
        } else {
            return false
        }
    }
}
