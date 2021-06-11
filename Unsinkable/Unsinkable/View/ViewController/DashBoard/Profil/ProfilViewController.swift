//
//  Profil.swift
//  Unsinkable
//
//  Created by Thomas on 18/05/2021.
//

import Foundation
import UIKit
import Firebase

class ProfilViewController: UIViewController, UITextFieldDelegate {
//    weak var coordinator: CoordinatorManager?
    weak var coordinator: HomeCoordinator?
    var data: CustomResponse?
    
    
    @IBAction func profilPictureButton(_ sender: UIButton) {
    }
    @IBAction func performChangeButton(_ sender: UIButton) {
    }
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        print("LogOut")
    }
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
//    private func createLogOutButton() {
//        let logOut = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem., target: <#T##Any?#>, action: <#T##Selector?#>)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Delete this coordinator, but create probleme whene pushing profil button again 
//        coordinator?.didFinishLogin()
    }
    private func setDelegate() {
        firstNameTextField.delegate = self
        firstNameTextField.isUserInteractionEnabled = false
        nameTextField.delegate = self
        nameTextField.isUserInteractionEnabled = false
        emailTextField.delegate = self
        emailTextField.isUserInteractionEnabled = false
        
    }
    
    private func setUserInfo() {
        self.firstNameTextField.placeholder = data?.user.firstName
        self.nameTextField.placeholder = data?.user.name
        self.emailTextField.placeholder = data?.user.email
    }
}
