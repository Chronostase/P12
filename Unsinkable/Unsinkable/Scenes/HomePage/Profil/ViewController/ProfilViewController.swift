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
        createLogOutButton()
        setDelegate()
        navigationController?.navigationBar.isHidden = false
    }
    private func createLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), style: .plain, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInfo()
//        profilButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 140, bottom: 0, right: 140)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc private func logout() {
        profilPresenter.logOut()
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
        self.firstNameTextField.placeholder = data?.user.firstName
        self.nameTextField.placeholder = data?.user.name
        self.emailTextField.placeholder = data?.user.email
    }
    
    func transitionToMainLoginPage() {
        coordinator?.parentCoordinator?.start()
        coordinator?.didFinish()
    }
    
    func showError(_ message: String) {
        print(message)
    }
}
