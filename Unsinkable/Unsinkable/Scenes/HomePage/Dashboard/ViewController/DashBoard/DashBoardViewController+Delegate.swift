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
    
    func fetchProjectComplete(_ result: Result<CustomResponse?,UnsinkableError>) {
        switch result {
        case .success(let customResponse):
            guard let userData = customResponse else {
                return
            }
            coordinator?.data = userData
            let projectList = userData.user.projects
            dashBoardPresenter.sortPersonalAndProfessionalProject(projectList)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.dismiss(animated: true, completion: {
                    self.isTabBarEnable(true)
                    self.reloadCollection()
                    self.setupEmptyView(self.dashBoardPresenter.personalProject, self.personalCollectionView)
                    self.setupEmptyView(self.dashBoardPresenter.professionalProject, self.professionalCollectionView)
                })
            }
        case .failure(let error):
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.dismiss(animated: true, completion: {
                    self.isTabBarEnable(true)
                    guard let messageBody = error.errorDescription else {return}
                    self.presentRetyAlert(message: messageBody, title: error.localizedDescription)
                })
            }
        }
    }
    
    
    func fetchUserDataComplete(_ result: Result<CustomResponse?,UnsinkableError>) {
        switch result {
        case .success(let customResponse):
            guard let userData = customResponse else {return}
            dashBoardPresenter.data? = userData
            dashBoardPresenter.getProjectList()
        case .failure(let error):
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.dismiss(animated: true, completion: {
                    self.isTabBarEnable(true)
                    self.setupEmptyView(self.dashBoardPresenter.personalProject, self.personalCollectionView)
                    self.setupEmptyView(self.dashBoardPresenter.professionalProject, self.professionalCollectionView)
                    guard let messageBody = error.errorDescription else {return}
                    self.presentRetyAlert(message: messageBody, title: error.localizedDescription)
                })
            }
        }
    }
    
    
    func fetchDateSucceed(_ date: String) {
        self.updateDateLabel(date)
    }
    
    func isTabBarEnable(_ authorization: Bool) {
        self.tabBarController?.tabBar.isUserInteractionEnabled = authorization
    }
}
