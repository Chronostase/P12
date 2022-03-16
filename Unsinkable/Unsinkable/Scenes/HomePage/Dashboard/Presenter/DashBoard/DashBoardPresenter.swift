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
    func getUserData(completion: @escaping (Result<CustomResponse, UnsinkableError>) -> Void)
    func getCurrentDate()
    func getProjectList()
    func createCurrentDate() -> String?
    func sortPersonalAndProfessionalProject(_ projectList: [Project?]?)
    func isSearchBarActive(_ text: String?) -> Bool
}

class DashBoardPresenter {
//    let userAuthenticationService: AuthenticationLogic = UserAuthenticationService()
    weak var delegate: DashBoardPresenterDelegate?
    var data: CustomResponse?
//    let projectService: ProjectLogic = ProjectService()
    var filtredData: [Project]?
    var personalProject: [Project]?
    var professionalProject: [Project]?
    var searchBarEntry: String?
    
    let service: AuthenticationLogic
    init (session: AuthenticationLogic = UserAuthenticationService()) {
        self.service = session
    }
    
    
    func fetchUser() {
        getUserData { result in
            switch result {
            case .success(let response):
                self.delegate?.fetchUserDataComplete(.success(response))
            case .failure(let error):
                self.delegate?.fetchUserDataComplete(.failure(error))
            }
        }
    }
}
