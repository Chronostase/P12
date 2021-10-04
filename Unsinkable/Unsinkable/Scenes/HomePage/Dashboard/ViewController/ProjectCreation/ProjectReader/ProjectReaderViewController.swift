//
//  ProjectReaderViewController.swift
//  Unsinkable
//
//  Created by Thomas on 29/09/2021.
//

import Foundation
import Kingfisher
import UIKit

class ProjectReaderViewController: UIViewController {
    weak var coordinator: HomeCoordinator?
    @IBOutlet var guestContentView: UIView!
    @IBOutlet var firstSeparator: UIView!
    @IBOutlet var descriptionContentView: UIView!
    @IBOutlet var SecondSeparator: UIView!
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var projectName: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var showMoreButton: UIButton!
    
    lazy var dashBoardPresenter = {
        return DashBoardPresenter()
    }()
    
    override func viewDidLoad() {
        setup()
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func showMoreButton(_ sender: UIButton) {
    }
    
    func setup() {
        setDelegate()
    }
    
    private func setDelegate() {
        self.taskTableView.dataSource = self
        self.taskTableView.delegate = self 
    }
    
    func configureVC() {
        guard let selectedProject = dashBoardPresenter.selectedProject else {return}
        if selectedProject.title != nil {
            self.projectName.text = selectedProject.title
        }
        
        if selectedProject.downloadUrl != nil {
            guard let downloadUrl = selectedProject.downloadUrl else {return}
            let url = URL(string: downloadUrl)
            self.coverImage.kf.setImage(with: url, placeholder: UIImage(named: "cover"), options: nil, completionHandler: nil)
        } else {
            self.coverImage.image = UIImage(named: "cover")
        }
        
        if selectedProject.description != nil {
            self.descriptionContentView.isHidden = false
            self.descriptionTextView.text = selectedProject.description
        } else {
            self.descriptionContentView.isHidden = true
        }
        
        #warning("Is possible that taskList != nil but [] in this case change condition")
        if selectedProject.taskList != nil {
            self.taskTableView.isHidden = false
        } else {
            self.taskTableView.isHidden = true
        }
//        if tasks != nil {
//            //RegisterCell
//        } else {
//            self.taskTableView.isHidden = true
//        }
    }
}
