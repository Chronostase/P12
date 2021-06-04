//
//  Profil.swift
//  Unsinkable
//
//  Created by Thomas on 18/05/2021.
//

import Foundation
import UIKit

class ProfilViewController: UIViewController, UITextFieldDelegate {
    weak var coordinator: CoordinatorManager?
    
    
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
        navigationController?.navigationBar.isHidden = false
    }
//    private func createLogOutButton() {
//        let logOut = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem., target: <#T##Any?#>, action: <#T##Selector?#>)
//    }
    private func setDelegate() {
        firstNameTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        
    }
}
