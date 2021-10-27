//
//  ProfiPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 16/06/2021.
//

import Foundation

protocol ProfilPresenterDelegate: AnyObject {
    func logoutSucceed()
    func logoutFailed() 
}

class ProfiPresenter {
    
    weak var delegate: ProfilPresenterDelegate?
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    var data: CustomResponse?
    
    func logOut() {
        if userAuthenticationService.logOut() == true {
            delegate?.logoutSucceed()
        } else {
            delegate?.logoutFailed()
        }
    }
}
