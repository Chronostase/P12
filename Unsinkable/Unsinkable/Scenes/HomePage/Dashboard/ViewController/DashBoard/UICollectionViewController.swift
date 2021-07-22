//
//  UICollectionViewController.swift
//  Unsinkable
//
//  Created by Thomas on 12/01/2021.
//

import UIKit


extension DashBoardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let projectListCount = dashBoardPresenter.data?.user.projects?.count else {
            return 0
        }
        return projectListCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as? CustomProjectCell else {
            return UICollectionViewCell()
        }
        
        guard let project = dashBoardPresenter.data?.user.projects?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.configureWith(project)
        return cell
    }
    

}

extension DashBoardViewController: UICollectionViewDelegate {
    
}

//Seem to don't work with xib
extension DashBoardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.75 , height: collectionView.frame.height * 0.90)
    }
}
