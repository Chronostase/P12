//
//  SignInViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit
import FBSDKLoginKit

class SignInViewController: UIViewController, VCCoordinator {
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    weak var coordinator: CoordinatorManager?
    var indicator = false
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
        if loginPresenter.checkTextFieldsAvailable(emailTextField.text, passwordTextField.text) {
            guard let email = emailTextField.text?.formatCharacter(),
                  let password = passwordTextField.text?.formatCharacter() else {
                return
            }
            
            userAuthenticationService.loginUser(email, password) { [weak self] result in
                switch result {
                case .success(_):
                    guard let view = self?.view else {
                        return
                    }
                    self?.coordinator?.transitionToHomeScreen(view)
                case .failure(_):
                    self?.showError("Incorrect log please retry.")
                }
            }
        }
    }
    
    func transitionToHomeScreen() {
        coordinator?.transitionToHomeScreen(self.view)
    }
    
    @IBAction func appleLoginButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
