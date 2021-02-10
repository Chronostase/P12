//
//  RegisterViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit

class RegisterViewController: UIViewController, VCCoordinator {
    weak var coordinator: CoordinatorManager?
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    
    //    var registerPresenter: REgisterPresenterProtocol? { didSet { register presenter.registerpresetnerviewdeleter = self }
    
    private lazy var registerPresenter = {
        return RegisterPresenter()
    }()
    let userAuthentificationService: AuthentificationLogic = UserAuthentificationService()
    @IBAction func createAccountButton(_ sender: UIButton) {
        // Something gonna wrong with validateFields
        if validateFields() != nil {
            guard let error = validateFields() else {
                return
            }
            showError(error)
        } else {
            formatFieldsAndCreateUser()
            coordinator?.transitionToHomeScreen(self.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerPresenter.registerDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func validateFields() -> String? {
        
        //Check if fields are empty
        
        guard checkTextFieldsAvailable(firstName: firstNameTextField.text, nameTextField.text, emailTextField.text, passwordTextField.text) else {
            return "Please fill in all fields."
        }
        // Check if correct password
        if checkPasswordAvailable(password: passwordTextField.text) {
            return nil
        } else {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
    }
    
    
    
    func showError(_ message: String) {
        // Error happend when login error, label equal nil
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func formatFieldsAndCreateUser() {
        guard let firstName = formatedString(string: firstNameTextField.text),
              let name = formatedString(string: nameTextField.text),
              let email = formatedString(string: emailTextField.text),
              let password = formatedString(string: passwordTextField.text) else {
            return showError("We can't format fields please retry")
        }
        userAuthentificationService.createUserWithInformations(firstName, name, email, password)
    }
}
extension RegisterViewController: RegisterPresenterDelegate {
    
    func checkPasswordAvailable(password: String?) -> Bool {
       return registerPresenter.checkIfPasswordIsCorrect(password: password)
    }
    
    
    func checkTextFieldsAvailable(firstName: String?, _ name: String?, _ email: String?, _ password: String?) -> Bool {
        return registerPresenter.checkTextFieldsAvailable(firstName: firstName, name, email, password)
    }
    
    
    func formatedString(string: String?) -> String? {
        let newString = registerPresenter.formatFields(string: string)
        
        return newString
    }
}
