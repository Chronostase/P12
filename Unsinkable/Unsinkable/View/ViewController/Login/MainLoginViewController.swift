//
//  MainLoginViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit

class MainLoginViewController: UIViewController, VCCoordinator {
    
    weak var coordinator: CoordinatorManager?
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var appLogo: UIImageView!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        coordinator?.signIn()
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        coordinator?.register()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUi() {
        registerButton.setTitle(Constants.LoginString.registerButton, for: .normal)
        loginButton.setTitle(Constants.LoginString.longinButton, for: .normal)
    }
}
