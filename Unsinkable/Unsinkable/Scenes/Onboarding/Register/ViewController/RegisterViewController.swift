//
//  RegisterViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//
import Foundation
import UIKit

class RegisterViewController: UIViewController {
    weak var coordinator: AuthenticationCoordinator?
//    @IBOutlet var mainLabel: UILabel!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    private lazy var registerPresenter = {
        return RegisterPresenter()
    }()
    let userAuthentificationService: AuthentificationLogic = UserAuthentificationService()
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        registerPresenter.registerWith(firstNameTextField.text, nameTextField.text, emailTextField.text, passwordTextField.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func transitionToHomeScreen() {
        coordinator?.transitionToHomeScreenNeeded()
        coordinator?.didFinishLogin()
    }
    
    private func setupDelegate() {
        registerPresenter.registerDelegate = self
        firstNameTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupUI() {
        emailTextField.setPlaceholder("Email...")
        firstNameTextField.setPlaceholder("Firstname...")
        nameTextField.setPlaceholder("Name...")
        passwordTextField.setPlaceholder("Password...")
        self.navigationItem.title = "Register"
        errorLabel.isHidden = true
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
