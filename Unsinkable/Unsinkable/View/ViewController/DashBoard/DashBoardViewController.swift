//
//  DashBoardViewController.swift
//  Unsinkable
//
//  Created by Thomas on 06/01/2021.
//

import UIKit

class DashBoardViewController: UIViewController {
    //    weak var coordinator: CoordinatorManager?
    weak var coordinator: HomeCoordinator?
    
    let userAuthenticationService: AuthentificationLogic = UserAuthentificationService()
    var data = CustomResponse(user: UserDetails())
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func profilButton(_ sender: UIButton) {
        coordinator?.profil()
        DispatchQueue.main.async {
//            guard let userData = self.userAuthenticationService.getUserData() else {
//                return
//            }
//            
//            self.data = userData
//            print(self.data.user.name)
        }
        
    }
    
    @IBAction func addProject(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setCollectionDelegateAndDataSource() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self 
    }
    
}
