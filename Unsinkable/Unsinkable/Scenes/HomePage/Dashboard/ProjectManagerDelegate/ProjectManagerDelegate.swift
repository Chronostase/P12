//
//  ProjectManagerDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/03/2022.
//

import Foundation

//project manager delegate with all methods relative to project
protocol ProjectManagerDelegate: AnyObject {
    func registerProjectComplete(_ result: Result<Project?,UnsinkableError>)
    func registerTaskComplete(_ result: Result<Void,UnsinkableError>)
    func fetchCurrentProjectComplete(_ result: Result<Void,UnsinkableError>)
    func fetchProjectComplete()
    
    func addTaskFromReaderComplete(_ result: Result<Void, UnsinkableError>)
    
    func updateLocalTask(_ task: Task)
    func updateTaskComplete(_ result: Result<Task?,UnsinkableError>)
    func updateValidateStatementComplete(_ result: Result<Task?, UnsinkableError>)
    func updateProjectComplete(_ result: Result<Project?, UnsinkableError>)
    
    func deleteTaskComplete(_ result: Result<Void,UnsinkableError>)
    func deleteProjectComplete(_ result: Result<Void, UnsinkableError>)
    
    func showErrorMessage(with message: String)
}

//Allow to attach only concerned method to each dependencies
extension ProjectManagerDelegate {
    func registerProjectComplete(_ result: Result<Project?,UnsinkableError>) {}
    func registerTaskComplete(_ result: Result<Void,UnsinkableError>) {}
    func fetchProjectComplete() {}
    func fetchCurrentProjectComplete(_ result: Result<Void,UnsinkableError>) {}
    
    func addTaskFromReaderComplete(_ result: Result<Void, UnsinkableError>) {}
    
    func updateLocalTask(_ task: Task) {}
    func updateTaskComplete(_ result: Result<Task?,UnsinkableError>) {}
    func updateValidateStatementComplete(_ result: Result<Task?, UnsinkableError>) {}
    func updateProjectComplete(_ result: Result<Project?, UnsinkableError>) {}
    
    func deleteTaskComplete(_ result: Result<Void,UnsinkableError>) {}
    
    func deleteProjectComplete(_ result: Result<Void, UnsinkableError>) {}
    func showErrorMessage(with message: String) {}
}
