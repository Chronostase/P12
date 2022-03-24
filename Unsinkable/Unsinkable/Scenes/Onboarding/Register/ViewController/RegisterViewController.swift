//
//  RegisterViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//
import Foundation
import UIKit
import IQKeyboardManagerSwift

class RegisterViewController: UIViewController {
    weak var coordinator: AuthenticationCoordinator?
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    private lazy var registerPresenter = {
        return RegisterPresenter()
    }()
    
    //Show loader and initiate registerUser process
    @IBAction func createAccountButton(_ sender: UIButton) {
        self.showLoader()
        registerPresenter.registerWith(firstNameTextField.text, nameTextField.text, emailTextField.text, passwordTextField.text)
    }
    
    //Setup delegate and UI
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
    
    //Disable IQKeyboardManager
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    //Call coordinator to push homeScreen
    func transitionToHomeScreen() {
        coordinator?.transitionToHomeScreenNeeded()
        coordinator?.didFinishLogin()
    }
    
    //Set item delegate to self
    private func setupDelegate() {
        registerPresenter.registerDelegate = self
        firstNameTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //Do viewController UI setup and enable IQKeyBoardManager
    private func setupUI() {
        IQKeyboardManager.shared.enable = true
        emailTextField.setPlaceholder(Constants.LoginString.emailPlaceHolder)
        firstNameTextField.setPlaceholder(Constants.LoginString.firstNamePlaceHolder)
        nameTextField.setPlaceholder(Constants.LoginString.namePlaceHolder)
        passwordTextField.setPlaceholder(Constants.LoginString.passwordPlaceHolder)
        self.navigationItem.title = Constants.LoginString.register
        errorLabel.isHidden = true
    }
    
    //Show error to user if incorrect data in fields
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
