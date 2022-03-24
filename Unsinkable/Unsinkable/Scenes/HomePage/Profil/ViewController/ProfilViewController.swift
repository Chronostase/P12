//
//  Profil.swift
//  Unsinkable
//
//  Created by Thomas on 18/05/2021.
//

import Foundation
import UIKit

class ProfilViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    lazy var profilPresenter = {
        return ProfilPresenter()
    }()
    
    @IBOutlet var profilButton: UIButton!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    //Feature in coming
    @IBAction func profilPictureButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setUserInfo()
    }
    //Setup Delegate and rightNavigationBar button
    private func setupVC() {
        errorLabel.isHidden = true
        addNavigationBarButton()
        setDelegate()
        navigationController?.navigationBar.isHidden = false
    }
    
    //Set item delegate to self
    private func setDelegate() {
        profilPresenter.delegate = self
        firstNameTextField.delegate = self
        firstNameTextField.isUserInteractionEnabled = false
        nameTextField.delegate = self
        nameTextField.isUserInteractionEnabled = false
        emailTextField.delegate = self
        emailTextField.isUserInteractionEnabled = false
    }
    //Allow to edit / perform profil change
    @IBAction func performChangeButton(_ sender: UIButton) {
        if sender.titleLabel?.text == Constants.Button.editProfil {
            self.canUserEdit(autorization: true)
            sender.setTitle(Constants.Button.saveChange, for: .normal)
        } else if sender.titleLabel?.text == Constants.Button.saveChange {
            updateUser()
            self.canUserEdit(autorization: false)
            sender.setTitle(Constants.Button.editProfil, for: .normal)
        }
    }
    
    //Allow user to edit or not his profil
    private func canUserEdit(autorization: Bool) {
        firstNameTextField.isUserInteractionEnabled = autorization
        nameTextField.isUserInteractionEnabled = autorization
        emailTextField.isUserInteractionEnabled = autorization
    }
    
    //UpdateUser with new data
    private func updateUser() {
        guard let firstName = firstNameTextField.text, let name = nameTextField.text, let email = emailTextField.text else {
            return
        }
        profilPresenter.updateUser(firstName, name, email)
        
    }
    
    //Display user Data
    private func setUserInfo() {
        self.firstNameTextField.text = profilPresenter.data?.user.firstName
        self.nameTextField.text = profilPresenter.data?.user.name
        self.emailTextField.text = profilPresenter.data?.user.email
    }
    
    //Transition to mainLogin if user logout / Delete his account
    func transitionToMainLoginPage() {
        coordinator?.parentCoordinator?.start()
        coordinator?.didFinish()
    }
    
    //add right bar button to show action sheet
    private func addNavigationBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), style: .plain, target: self, action: #selector(showOptions))
    }
    
    //Offer option to user to logout or delete his account with confirmation dialog
    @objc private func showOptions() {
        let actionSheet = UIAlertController(title: Constants.Button.moreOptions, message: nil, preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: Constants.Button.logout, style: .default) { action in
            self.profilPresenter.logOut()
        }
        let deleteUser = UIAlertAction(title: Constants.Button.deleteUserAccount, style: .destructive) { (action) in
            self.setConfirmationDialog()
        }
        let cancel = UIAlertAction(title: Constants.Button.cancel, style: .cancel, handler: nil)
        
        let actionArry = [logout, deleteUser, cancel]
        for action in actionArry {
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    //Set Confirmation dialog before erase user profil 
    private func setConfirmationDialog() {
        let confirmationDialog = UIAlertController(title: Constants.Button.deleteAccount, message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: Constants.Button.yes, style: .destructive) { action in
            self.showLoader()
            self.profilPresenter.deleteAllUserRef()
        }
        
        let cancel = UIAlertAction(title: Constants.Button.cancel, style: .cancel, handler: nil)
        
        let actionArray = [delete, cancel]
        
        for action in actionArray {
            confirmationDialog.addAction(action)
        }
        present(confirmationDialog, animated: true, completion: nil)
    }
}
