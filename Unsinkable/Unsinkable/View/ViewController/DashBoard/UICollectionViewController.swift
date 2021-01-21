//
//  UICollectionViewController.swift
//  Unsinkable
//
//  Created by Thomas on 12/01/2021.
//

import UIKit


extension DashBoardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell() 
    }
    

}

extension DashBoardViewController: UICollectionViewDelegate {
    
}
