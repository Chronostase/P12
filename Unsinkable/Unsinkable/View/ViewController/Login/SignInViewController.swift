//
//  SignInViewController.swift
//  Unsinkable
//
//  Created by Thomas on 20/01/2021.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var appleLogin: UIButton!
    @IBOutlet var faceBookLogin: UIButton!
    @IBOutlet var twitterLogin: UIButton!
    
    
    @IBAction func signInButton(_ sender: UIButton) {
    }
    @IBAction func appleLoginButton(_ sender: UIButton) {
    }
    @IBAction func faceBookLoginButton(_ sender: UIButton) {
    }
    @IBAction func twitterLoginButton(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
