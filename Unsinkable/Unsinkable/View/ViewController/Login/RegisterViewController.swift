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
    
    let userAuthentificationService: AuthentificationLogic = UserAuthentificationService()
    @IBAction func createAccountButton(_ sender: UIButton) {
        // Something gonna wrong with validateFields
        if validateFields() != nil {
            guard let error = validateFields() else {
                return
            }
            showError(error)
        } else {
            guard let firstName = firstNameTextField.text?.formatCharacter(),
            let name = nameTextField.text?.formatCharacter(),
            let email = emailTextField.text?.formatCharacter(),
            let password = passwordTextField.text?.formatCharacter() else {
                return
            }
            UserAuthentificationService().createUserWithInformations(firstName, name, email, password)
            transitionToHomeScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func validateFields() -> String? {
        
        //Check if fields are empty
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        // Check if correct password
        if checkIfPasswordIsCorrect() {
            return nil
        } else {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
    }
    
    private func checkIfPasswordIsCorrect() -> Bool {
        guard let cleanedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            
            return false
        }
        
        if Utilities.isPasswordValide(cleanedPassword) {
            
            return true
        } else {
            
            return false
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func transitionToHomeScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainStoryBoard = storyBoard.instantiateViewController(withIdentifier: "main") as? UITabBarController else {
            return
        }
        view.window?.rootViewController = mainStoryBoard
        view.window?.makeKeyAndVisible()

    }
}
