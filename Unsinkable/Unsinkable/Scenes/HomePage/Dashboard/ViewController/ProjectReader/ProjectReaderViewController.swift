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
    
    let debouncer = Debouncer(timeInterval: 0.5)
    
    lazy var projectReaderPresenter = {
        return ProjectReaderPresenter()
    }()
    
    override func viewDidLoad() {
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        projectReaderPresenter.refreshCurrentProject()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
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
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(moreOptionTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func moreOptionTapped() {
        showMoreOptions()
    }
    
    private func showMoreOptions() {
        let actionSheet = UIAlertController(title: "More Options", message: nil, preferredStyle: .actionSheet)
        let deleteProject = UIAlertAction(title: "Delete Project", style: .destructive) { (action) in
            self.setConfirmationDialog()
            print("Delete Project Option Tapped")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionArry = [deleteProject, cancel]
        for action in actionArry {
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func setDelegate() {
        self.projectReaderPresenter.delegate = self 
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
    
    private func setConfirmationDialog() {
        let confirmationDialog = UIAlertController(title: "Are you want to delete this item", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "Yes", style: .destructive) { action in
            self.projectReaderPresenter.deleteProject()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionArray = [delete, cancel]
        
        for action in actionArray {
            confirmationDialog.addAction(action)
        }
        present(confirmationDialog, animated: true, completion: nil)
    }
    
    private func showLoader() {
        let loadingVC = LoaderViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        navigationController?.present(loadingVC, animated: true, completion: nil)
    }
}
