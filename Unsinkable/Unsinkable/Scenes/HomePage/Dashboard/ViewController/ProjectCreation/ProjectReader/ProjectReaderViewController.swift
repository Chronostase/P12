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
    
    lazy var projectReaderPresenter = {
        return ProjectReaderPresenter()
    }()
    
    override func viewDidLoad() {
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func showMoreButton(_ sender: UIButton) {
    }
    
    func setup() {
        setDelegate()
        registerCell()
        configureViewController()
        addRightNavigationBarButton()
    }
    
    private func addRightNavigationBarButton() {
        guard let image = UIImage(systemName: "ellipsis") else {
            return
        }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightBarbuttonTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func rightBarbuttonTapped() {
        
    }
    
    private func setDelegate() {
        self.taskTableView.dataSource = self
        self.taskTableView.delegate = self 
    }
    
    private func configureViewController() {
        guard let project = projectReaderPresenter.selectedProject else {
            return
        }
        
        if projectReaderPresenter.checkIfTitleIsNil() {
            self.projectName.isHidden = true
        } else {
            self.projectName.isHidden = false
            self.projectName.text = project.title
        }
        
        if projectReaderPresenter.checkIfCoverPicture() {
            guard let downloadUrl = project.downloadUrl else {
                self.coverImage.image = UIImage(named: "cover")
                return
            }
            let url = URL(string: downloadUrl)
            self.coverImage.kf.setImage(with: url, placeholder: UIImage(named: "cover"), options: nil, completionHandler: nil)
        }
        
        if projectReaderPresenter.checkIfDescriptionIsEmpty() {
            self.descriptionContentView.isHidden = true
        } else {
            self.descriptionContentView.isHidden = false
            self.descriptionTextView.text = project.description
        }
        
        if projectReaderPresenter.checkIfTaskListIsEmpty() {
            self.taskTableView.isHidden = true
        } else {
            self.taskTableView.isHidden = false
        }
        
        self.guestContentView.isHidden = true
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        taskTableView.register(nib, forCellReuseIdentifier: "TaskCell")
    }
}
