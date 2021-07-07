//
//  DashBoardPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 22/06/2021.
//

import Foundation

protocol DashBoardPresenterDelegate: AnyObject {
    func fetchDateSucceed(_ date: String)
}

class DashBoardPresenter {
    var data: CustomResponse?
    weak var delegate: DashBoardPresenterDelegate?
    let projectService: ProjectLogic = ProjectService()
    
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
}
