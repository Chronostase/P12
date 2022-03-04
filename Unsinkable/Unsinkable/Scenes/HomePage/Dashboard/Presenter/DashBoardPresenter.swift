//
//  DashBoardPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 22/06/2021.
//

import Foundation

protocol DashBoardPresenterDelegate: AnyObject {
    func fetchDateSucceed(_ date: String)
    
    func fetchUserDataComplete(_ result: Result<CustomResponse?,UnsinkableError>)
    func fetchProjectComplete(_ result: Result<CustomResponse?, UnsinkableError>)
}

protocol DashBoardPresenterLogic {
    func getUserData()
    func getCurrentDate()
    func getProjectList()
    func createCurrentDate() -> String?
    func sortPersonalAndProfessionalProject(_ projectList: [Project?]?)
    func isSearchBarActive(_ text: String?) -> Bool
}

class DashBoardPresenter {
    let userAuthenticationService: AuthenticationLogic = UserAuthenticationService()
    weak var delegate: DashBoardPresenterDelegate?
    var data: CustomResponse?
    let projectService: ProjectLogic = ProjectService()
    var filtredData: [Project]?
    var personalProject: [Project]?
    var professionalProject: [Project]?
    var searchBarEntry: String? 
    
    
    func fetchUser() {
        getUserData()
    }
//    func getCurrentDate() {
//        guard let date = createCurrentDate() else {
//            return
//        }
//        delegate?.fetchDateSucceed(date)
//    }

//    func getUserData() {
//        userAuthenticationService.getUserData { [weak self] result in
//            switch result {
//            case .success(let customResponse):
//                guard let userData = customResponse else {
//                    return
//                }
//                self?.data = userData
//                self?.delegate?.fetchUserDataComplete(.success(userData))
//            case.failure(let error):
//                self?.delegate?.fetchUserDataComplete(.failure(error))
//            }
//        }
//    }

//    func getProjectList() {
//        userAuthenticationService.fetchProjects(data) { [weak self] result in
//            switch result {
//            case .success(let projectList):
//                self?.data?.user.projects = projectList
//                self?.delegate?.fetchProjectComplete(.success(self?.data))
//
//            case .failure(let error):
//                self?.delegate?.fetchProjectComplete(.failure(error))
//                print("Can't fetch project \(error)")
//            }
//        }
//    }

//    private func createCurrentDate() -> String? {
//        let currentDateTime = Date()
//        let formatter = DateFormatter()
//        formatter.timeStyle = .none
//        formatter.dateStyle = .long
//
//        return formatter.string(from: currentDateTime)
//    }


//    func sortPersonalAndProfessionalProject(_ projectList: [Project?]?) {
//        guard let projectList = projectList else {return}
//        professionalProject = [Project]()
//        personalProject = [Project]()
//        for project in projectList {
//            guard let project = project else {return}
//            if project.isPersonal == true {
//                personalProject?.append(project)
//            } else {
//                professionalProject?.append(project)
//            }
//        }
//    }

//    func isSearchBarActive(_ text: String?) -> Bool {
//        if let text = text {
//            return !text.isEmpty
//        } else {
//            return false
//        }
//    }
}
