//
//  SignInViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit

class LogInViewController: UIViewController {
    let userAuthenticationService: AuthenticationLogic = UserAuthenticationService()
    weak var coordinator: AuthenticationCoordinator?
    lazy var loginPresenter = {
        return LoginPresenter()
    }()
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var appleLogin: UIButton!
    
    //Launch Loader and call presenter to initiate login process
    @IBAction func signInButton(_ sender: UIButton) {
        self.showLoader()
        loginPresenter.login(emailTextField.text, passwordTextField.text)
    }
    
    //Call coordinator to push to homeScreen
    func transitionToHomeScreen() {
        coordinator?.transitionToHomeScreenNeeded()
        coordinator?.didFinishLogin() 
    }
    
    //Will serve later with Premium Apple Account
    @IBAction func appleLoginButton(_ sender: UIButton) {
    }
    
    //Set delegate and ViewController UI
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
    }
    
    //Do additional viewController setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //Set item delegate to self
    private func setupDelegate() {
        loginPresenter.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //Setup ViewController UI
    private func setupUI() {
        errorLabel.isHidden = true
        signInButton.setTitle(Constants.LoginString.signIn, for: .normal)
        orLabel.text = Constants.LoginString.or
        appleLogin.setTitle(Constants.LoginString.appleLogin, for: .normal)
        
        self.navigationItem.title = Constants.LoginString.signIn
        emailTextField.setPlaceholder(Constants.LoginString.emailPlaceHolder)
        passwordTextField.setPlaceholder(Constants.LoginString.passwordPlaceHolder)
    }
    
    //Show error if incorrect login
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
