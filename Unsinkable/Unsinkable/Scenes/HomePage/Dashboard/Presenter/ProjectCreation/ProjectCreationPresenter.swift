//
//  ProjectCreationPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation

protocol ProjectCreationLogic {
    func registerProject(_ title: String?,_ descitpion: String?,_ coverPicture: Data?, completion: @escaping (Result<Project?, UnsinkableError>) -> Void)
    func registerTask(_ project: Project?)
    func createProjectObject( withTitle: String?,_ description: String?,_ projectOwner: String?, tasks: [Task?]?)
    func checkTextFieldsAvailable(_ title: String?, _ description: String?) -> Bool
    func checkTaskTitle(_ taskTitle: String?) -> Bool
    func createTaskObject(_ title: String?, _ projectID: String?, _ taskID: String?, _ priority: Bool? , _ deadLine: Date?, _ commentary: String?, _ location: String?) -> Task
    func isFieldFill(_ field: String?) -> Bool
    func updateProject(_ title: String?)
    func updateLocalTaskData(withTask: Task?)
}

class ProjectCreationPresenter {
    
    
    weak var delegate: ProjectManagerDelegate?
    var data: CustomResponse?
    var project: Project?
    var localTasksList: [Task?]? = []
    var editedTask: Task?
    var isPersonal: Bool?
    let service: ProjectLogic
    init (session: ProjectLogic = ProjectService()) {
        self.service = session
    }
    
    //Initiate save project process, call delegate methode to handle result 
    func saveProject(_ title: String?,_ descitpion: String?,_ coverPicture: Data?) {
        registerProject(title, descitpion, coverPicture) { result in
            switch result {
            case .success(let project):
                self.delegate?.registerProjectComplete(.success(project))
            case .failure(let error):
                self.delegate?.registerProjectComplete(.failure(error))
            }
        }
    }
}
