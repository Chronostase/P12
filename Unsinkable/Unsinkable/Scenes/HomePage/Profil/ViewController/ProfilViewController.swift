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
        return ProfiPresenter()
    }()
    
    
    @IBOutlet var profilButton: UIButton!
    @IBAction func profilPictureButton(_ sender: UIButton) {
    }
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
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        print("LogOut")
    }
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    private func canUserEdit(autorization: Bool) {
        firstNameTextField.isUserInteractionEnabled = autorization
        nameTextField.isUserInteractionEnabled = autorization
        emailTextField.isUserInteractionEnabled = autorization
    }
    private func updateUser() {
        //Non sens to check if fields fill, + fields can be "" and not nil, finally to update, if textField .Text != user.data -> update else keep old Value
        let user = profilPresenter.data?.user
            guard let firstName = firstNameTextField.text, let name = nameTextField.text, let email = emailTextField.text else {return}
            profilPresenter.updateUser(firstName, name, email)
        
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
        self.firstNameTextField.text = profilPresenter.data?.user.firstName
        self.nameTextField.text = profilPresenter.data?.user.name
        self.emailTextField.text = profilPresenter.data?.user.email
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
    
    private func setConfirmationDialog() {
        let confirmationDialog = UIAlertController(title: Constants.Button.deleteAccount, message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: Constants.Button.yes, style: .destructive) { action in
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
