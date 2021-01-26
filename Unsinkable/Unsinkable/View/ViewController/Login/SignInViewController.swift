//
//  SignInViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit

class SignInViewController: UIViewController, VCCoordinator {
    weak var coordinator: CoordinatorManager?
    
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var appleLogin: UIButton!
    @IBOutlet var faceBookLogin: UIButton!
    @IBOutlet var twitterLogin: UIButton!
    
    
    @IBAction func signInButton(_ sender: UIButton) {
    }
    @IBAction func appleLoginButton(_ sender: UIButton) {
    }
    @IBAction func faceBookLoginButton(_ sender: UIButton) {
    }
    @IBAction func twitterLoginButton(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
