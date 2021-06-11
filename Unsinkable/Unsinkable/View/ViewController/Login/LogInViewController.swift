//
//  SignInViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit
import FBSDKLoginKit

class LogInViewController: UIViewController {
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    weak var coordinator: AuthenticationCoordinator?
    lazy var loginPresenter = {
        return LoginPresenter()
    }()
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var appleLogin: UIButton!
    @IBOutlet var faceBookLogin: UIButton!
    
    
    @IBAction func signInButton(_ sender: UIButton) {
        loginPresenter.login(email: emailTextField.text, password: passwordTextField.text)
    }
    
    func transitionToHomeScreen() {
        coordinator?.transitionToHomeScreenNeeded()
        coordinator?.didFinishLogin() 
    }
    
    @IBAction func appleLoginButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupDelegate() {
        loginPresenter.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupUI() {
        errorLabel.isHidden = true
        signInButton.setTitle(Constants.LoginString.signInButton, for: .normal)
        orLabel.text = Constants.LoginString.or
        appleLogin.setTitle(Constants.LoginString.appleLogin, for: .normal)
        
        self.navigationItem.title = "Sign in"
        emailTextField.setPlaceholder("Email...")
        passwordTextField.setPlaceholder("Password...")
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
