//
//  Profil.swift
//  Unsinkable
//
//  Created by Thomas on 18/05/2021.
//

import Foundation
import UIKit

class ProfilViewController: UIViewController, UITextFieldDelegate {
    
    weak var coordinator: HomeCoordinator?
    lazy var profilPresenter = {
        return ProfiPresenter()
    }()
    
    
    @IBOutlet var profilButton: UIButton!
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
        setupVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupVC() {
        errorLabel.isHidden = true
        addNavigationBarButton()
        setDelegate()
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setDelegate() {
        profilPresenter.delegate = self
        firstNameTextField.delegate = self
        firstNameTextField.isUserInteractionEnabled = false
        nameTextField.delegate = self
        nameTextField.isUserInteractionEnabled = false
        emailTextField.delegate = self
        emailTextField.isUserInteractionEnabled = false
    }
    
    private func setUserInfo() {
        self.firstNameTextField.placeholder = profilPresenter.data?.user.firstName
        self.nameTextField.placeholder = profilPresenter.data?.user.name
        self.emailTextField.placeholder = profilPresenter.data?.user.email
    }
    
    func transitionToMainLoginPage() {
        coordinator?.parentCoordinator?.start()
        coordinator?.didFinish()
    }
    
    func showError(_ message: String) {
        print(message)
    }
    
    private func addNavigationBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), style: .plain, target: self, action: #selector(showOptions))
    }
    
    @objc private func showOptions() {
        let actionSheet = UIAlertController(title: "More Options", message: nil, preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: "Logout", style: .default) { action in
            self.profilPresenter.logOut()
        }
        let deleteUser = UIAlertAction(title: "Delete User account", style: .destructive) { (action) in
            self.setConfirmationDialog()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionArry = [logout, deleteUser, cancel]
        for action in actionArry {
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func setConfirmationDialog() {
        let confirmationDialog = UIAlertController(title: "Are you want to delete this account", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "Yes", style: .destructive) { action in
            self.profilPresenter.deleteAllUserRef()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionArray = [delete, cancel]
        
        for action in actionArray {
            confirmationDialog.addAction(action)
        }
        present(confirmationDialog, animated: true, completion: nil)
    }
}
