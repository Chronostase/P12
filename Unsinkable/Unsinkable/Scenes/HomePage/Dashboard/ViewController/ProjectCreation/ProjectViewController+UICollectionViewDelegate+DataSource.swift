//
//  ProjectViewController+UICollectionViewDelegate+DataSource.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation
import UIKit

extension ProjectViewController: UICollectionViewDelegate {
    
}

extension ProjectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
