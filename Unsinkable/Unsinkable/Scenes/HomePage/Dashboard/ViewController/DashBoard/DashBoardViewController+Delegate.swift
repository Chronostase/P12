//
//  DashBoardViewController+Delegate.swift
//  Unsinkable
//
//  Created by Thomas on 22/06/2021.
//

import Foundation

extension DashBoardViewController: DashBoardPresenterDelegate {
    
    func fetchDateSucceed(_ date: String) {
        self.updateDateLabel(date)
    }
    
    
}
