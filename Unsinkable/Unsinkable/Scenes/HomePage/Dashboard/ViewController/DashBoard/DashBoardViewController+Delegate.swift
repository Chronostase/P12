//
//  DashBoardViewController+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 22/06/2021.
//

import Foundation

extension DashBoardViewController: DashBoardPresenterDelegate {
    func launchLoader() {
        self.showLoader()
    }
    
    func fetchProjectSucceed(_ userData: CustomResponse?) {
        guard let userData = userData else {
            return
        }
        coordinator?.data = userData
        guard let projectList = userData.user.projects else {
        return }
        dashBoardPresenter.sortPersonalAndProfessionalProject(projectList)
        DispatchQueue.main.async {
            self.personalCollectionView.reloadData()
            self.professionalCollectionView.reloadData()
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func fetchProjectFailed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func fetchUserDataSucceed(_ userData: CustomResponse) {
        dashBoardPresenter.getProjectList()
    }
    
    func fetchUserDataFailed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func fetchDateSucceed(_ date: String) {
        self.updateDateLabel(date)
    }
    
    
}
