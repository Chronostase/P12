//
//  DashBoardPresenter + DashBoardPresenterLogic.swift
//  Unsinkable
//
//  Created by Thomas on 03/03/2022.
//

import Foundation

extension DashBoardPresenter: DashBoardPresenterLogic {
    
    //Call service to get user data
    func getUserData(completion: @escaping (Result<CustomResponse, UnsinkableError>) -> Void) {
        service.getUserData { [weak self] result in
            switch result {
            case .success(let customResponse):
                guard let userData = customResponse else {
                    return
                }
                
                self?.data = userData
                completion(.success(userData))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //Call service to fetch user project
    func getProjectList() {
        service.fetchProjects(data) { [weak self] result in
            switch result {
            case .success(let projectList):
                self?.data?.user.projects = projectList
                self?.delegate?.fetchProjectComplete(.success(self?.data))

            case .failure(let error):
                self?.delegate?.fetchProjectComplete(.failure(error))
            }
        }
    }
    
    //Get current date and display it
    func getCurrentDate() {
        guard let date = createCurrentDate() else {
            return
        }
        delegate?.fetchDateSucceed(date)
    }
    
    //Create currentDate
    func createCurrentDate() -> String? {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long

        return formatter.string(from: currentDateTime)
    }
    
    //Sort projectList in twoo section professional/personal
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
    
    //Check if search bar is active
    func isSearchBarActive(_ text: String?) -> Bool {
        if let text = text {
            return !text.isEmpty
        } else {
            return false
        }
    }
}
