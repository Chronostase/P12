//
//  DashBoardViewController.swift
//  Unsinkable
//
//  Created by Thomas on 06/01/2021.
//

import UIKit

class DashBoardViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func addProject(_ sender: Any) {
        pushProjectCreationVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setCollectionDelegateAndDataSource() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self 
    }
    
    private func pushProjectCreationVC() {
        let storyBoard = UIStoryboard(name: "ProjectCreation", bundle: nil)
        guard let projectCreationViewController = storyBoard.instantiateInitialViewController() as? ProjectCreationViewController else {
            return
        }
        push(projectCreationViewController)
    }
}
