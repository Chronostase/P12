//
//  UICollectionViewController.swift
//  Unsinkable
//
//  Created by Thomas on 12/01/2021.
//

import UIKit


extension DashBoardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == personalCollectionView {
            guard let projectList = dashBoardPresenter.personalProject else {
                return 0
            }
            
            return projectList.count
            
        } else {
            guard let projectList = dashBoardPresenter.professionalProject else {
                return 0
            }
            
            return projectList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == personalCollectionView {
            guard let cell = personalCollectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as? CustomProjectCell else {
                return UICollectionViewCell()
            }
            guard let projects = dashBoardPresenter.personalProject else {
                return UICollectionViewCell()
            }
            if projects.count > 0 {
                
                let project = projects[indexPath.row]
                DispatchQueue.main.async {
                    cell.configureWith(project)
                }
            } else {
                return UICollectionViewCell()
            }
            
            return cell
        } else {
            guard let cell = professionalCollectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as? CustomProjectCell else {
                return UICollectionViewCell()
            }
            guard let projects = dashBoardPresenter.professionalProject else {
                return UICollectionViewCell()
            }
            
            if projects.count > 0 {
                let project = projects[indexPath.row]
                cell.configureWith(project)
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
    }
}

extension DashBoardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == personalCollectionView {
            guard let projects = dashBoardPresenter.personalProject else {
                return
            }
            let selectedProject = projects[indexPath.row]
//            dashBoardPresenter.selectedProject = selectedProject
            coordinator?.projectReader(project: selectedProject)
        } else {
            guard let projects = dashBoardPresenter.professionalProject else {
                return
            }
            let selectedProject = projects[indexPath.row]
            
//            dashBoardPresenter.selectedProject = selectedProject
            coordinator?.projectReader(project: selectedProject)
        }
    }
}

//Seem to don't work with xib
extension DashBoardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == personalCollectionView {
            
            let size = CGSize(width: personalCollectionView.frame.width * 0.75 , height: collectionView.frame.height * 0.90)
            return size
        } else {
            
            let size = CGSize(width: professionalCollectionView.frame.width * 0.75 , height: collectionView.frame.height * 0.90)
            return size
        }
    }
}
