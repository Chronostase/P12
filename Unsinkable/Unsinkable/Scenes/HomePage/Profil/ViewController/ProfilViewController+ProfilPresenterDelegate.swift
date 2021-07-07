//
//  ProfilViewController+ProfilPresenterDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 16/06/2021.
//

import Foundation

extension ProfilViewController: ProfilPresenterDelegate {
    func logoutSucceed() {
        self.transitionToMainLoginPage()
    }
    
    func logoutFailed() {
        self.showError("An error occured please retry")
    }
    
    
}
