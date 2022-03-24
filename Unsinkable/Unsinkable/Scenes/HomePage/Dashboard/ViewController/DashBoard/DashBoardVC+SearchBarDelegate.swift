//
//  DashBoardVC+SearchBarDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 01/02/2022.
//

import Foundation
import UIKit
extension DashBoardViewController: UISearchBarDelegate {
    
    //Add project in filtred data whil user is typing 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dashBoardPresenter.filtredData = []
        if let projectList = dashBoardPresenter.data?.user.projects {
            for project in projectList {
                guard let project = project, let lowerTitle = project.title else {return}
                if lowerTitle.lowercased().contains(searchText.lowercased()) {
                    dashBoardPresenter.filtredData?.append(project)
                }
            }
        }
    }
    
    //Sort collection view with user entry key word
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if dashBoardPresenter.isSearchBarActive(searchBar.text) {
            dashBoardPresenter.searchBarEntry = searchBar.text
            dashBoardPresenter.sortPersonalAndProfessionalProject(dashBoardPresenter.filtredData)
            DispatchQueue.main.async {
                self.reloadCollection()
            }
        } else {
            dashBoardPresenter.sortPersonalAndProfessionalProject(dashBoardPresenter.data?.user.projects)
            DispatchQueue.main.async {
                self.reloadCollection()
            }
        }
        searchBar.resignFirstResponder()
    }
}
