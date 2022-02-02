//
//  DashBoardPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 22/06/2021.
//

import Foundation

protocol DashBoardPresenterDelegate: AnyObject {
    func fetchDateSucceed(_ date: String)
    func fetchUserDataSucceed(_ userData: CustomResponse)
    func fetchUserDataFailed()
    func fetchProjectSucceed(_ userData: CustomResponse?)
    func fetchProjectFailed()
}

class DashBoardPresenter {
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    weak var delegate: DashBoardPresenterDelegate?
    var data: CustomResponse?
    let projectService: ProjectLogic = ProjectService()
    var filtredData: [Project]?
    var personalProject: [Project]?
    var professionalProject: [Project]?
    var searchBarEntry: String? 
    
    func getCurrentDate() {
        guard let date = createCurrentDate() else {
            return
        }
        delegate?.fetchDateSucceed(date)
    }
    
    private func createCurrentDate() -> String? {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        
        return formatter.string(from: currentDateTime)
    }
    
    func getUserData() {
        userAuthenticationService.getUserData { [weak self] result in
            switch result {
            case .success(let customResponse):
                guard let userData = customResponse else {
                    return 
                }
                self?.data = userData
                self?.delegate?.fetchUserDataSucceed(userData)
            case.failure(let error):
                self?.delegate?.fetchUserDataFailed()
                print("Can't fetch data \(error) ")
            }
        }
    }
    
    func sortPersonalAndProfessionalProject(_ projectList: [Project?]?) {
        guard let projectList = projectList else {return}
        professionalProject = [Project]()
        personalProject = [Project]()
        for project in projectList {
            guard let project = project else {return}
            if project.isPersonal == true {
                personalProject?.append(project)
            } else {
                professionalProject?.append(project)
            }
        }
    }
    
    func getProjectList() {
        userAuthenticationService.fetchProjects(data) { [weak self] result in
            switch result {
            case .success(let projectList):
                self?.data?.user.projects = projectList
                self?.delegate?.fetchProjectSucceed(self?.data)
                
            case .failure(let error):
                self?.delegate?.fetchProjectFailed()
                print("Can't fetch project \(error)")
            }
        }
    }
    
    func isSearchBarActive(_ text: String?) -> Bool {
        if let text = text {
            return !text.isEmpty
        } else {
            return false 
        }
    }
}
