//
//  Project.swift
//  Unsinkable
//
//  Created by Thomas on 29/06/2021.
//

import Foundation
import UIKit

class ProjectViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    
    @IBAction func nextButton(_ sender: Any) {
        coordinator?.taskCreation()
    }
    @IBOutlet var membersCollectionView: UICollectionView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var titleTextField: CustomTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setDelegate() {
        self.membersCollectionView.delegate = self
        self.membersCollectionView.dataSource = self 
        self.titleTextField.delegate = self 
    }
    
}
