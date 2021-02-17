//
//  SignInViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit
import FBSDKLoginKit

class SignInViewController: UIViewController, VCCoordinator {
    let userAuthentificationService: AuthentificationLogic = UserAuthentificationService()
    weak var coordinator: CoordinatorManager?
    lazy var loginPresenter = {
        return LoginPresenter()
    }()
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var appleLogin: UIButton!
    @IBOutlet var faceBookLogin: UIButton!
    @IBOutlet var twitterLogin: UIButton!
    
    
    @IBAction func signInButton(_ sender: UIButton) {
        if loginPresenter.checkTextFieldsAvailable(emailTextField.text, passwordTextField.text) {
            guard let email = emailTextField.text?.formatCharacter(),
                  let password = passwordTextField.text?.formatCharacter() else {
                return
            }
            userAuthentificationService.loginUser(email, password)
            coordinator?.transitionToHomeScreen(self.view)
        }
    }
    
    @IBAction func appleLoginButton(_ sender: UIButton) {
    }
    
    @IBAction func twitterLoginButton(_ sender: UIButton) {
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
        signInButton.setTitle("Sign in", for: .normal)
        orLabel.text = "Or"
        appleLogin.setTitle("Login with Apple", for: .normal)
        faceBookLogin.setTitle("Login with Facebook", for: .normal)
        twitterLogin.setTitle("Login with Facebook", for: .normal)
    }
}
