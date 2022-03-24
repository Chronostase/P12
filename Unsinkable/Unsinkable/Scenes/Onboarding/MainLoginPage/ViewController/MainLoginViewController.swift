//
//  MainLoginViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit

class MainLoginViewController: UIViewController {
    let userAuthenticationService: AuthenticationLogic = UserAuthenticationService()
    weak var coordinator: AuthenticationCoordinator?
    lazy var mainLoginPresenter: MainLoginPresenter = {
        return MainLoginPresenter()
    }()
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var appLogo: UIImageView!
    
    //Call coordinator to push LoginViewController
    @IBAction func loginTapped(_ sender: UIButton) {
        coordinator?.signIn()
    }
    
    //Call coordinator to push RegisterViewController
    @IBAction func registerTapped(_ sender: UIButton) {
        coordinator?.register()
    }
    
    //Setup ViewController UI
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupVC()
    }
    
    //Do additionnal setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //Setup ViewController UI And manage Stack
    private func setupVC() {
        setupUI()
        guard let navStack = self.navigationController?.viewControllers else {return}
        if mainLoginPresenter.navStackNeedManage(navStack.count) {
            removeFirstVCFromNavStack()
        }
    }
    
    //Set title to button
    private func setupUI() {
        registerButton.setTitle(Constants.LoginString.register, for: .normal)
        loginButton.setTitle(Constants.LoginString.longinButton, for: .normal)
    }
    
    //Remove FirstIndex in navigationStack
    private func removeFirstVCFromNavStack() {
        self.navigationController?.viewControllers.remove(at: 0)
    }
}

