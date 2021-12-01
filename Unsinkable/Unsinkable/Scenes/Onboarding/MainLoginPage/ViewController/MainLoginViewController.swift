//
//  MainLoginViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit

class MainLoginViewController: UIViewController {
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    weak var coordinator: AuthenticationCoordinator?
    lazy var mainLoginPresenter: MainLoginPresenter = {
        return MainLoginPresenter()
    }()
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var appLogo: UIImageView!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        coordinator?.signIn()
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        coordinator?.register()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupVC() {
        setupUI()
        guard let navStack = self.navigationController?.viewControllers else {return}
        if mainLoginPresenter.navStackNeedManage(navStack.count) {
            removeFirstVCFromNavStack()
        }
    }
    
    private func setupUI() {
        registerButton.setTitle(Constants.LoginString.registerButton, for: .normal)
        loginButton.setTitle(Constants.LoginString.longinButton, for: .normal)
    }
    
    private func removeFirstVCFromNavStack() {
        self.navigationController?.viewControllers.remove(at: 0)
    }
}

