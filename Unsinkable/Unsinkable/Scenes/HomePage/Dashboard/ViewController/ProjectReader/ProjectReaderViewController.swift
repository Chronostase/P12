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
    @IBOutlet var taskTextField: CustomTextField!
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var showMoreButton: UIButton!
    
    let debouncer = Debouncer(timeInterval: 0.5)
    
    lazy var projectReaderPresenter = {
        return ProjectReaderPresenter()
    }()
    
    override func viewDidLoad() {
        setup()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        projectReaderPresenter.refreshCurrentProject()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()
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
        guard let image = UIImage(systemName: Constants.Image.ellipsis) else {
            return
        }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(moreOptionTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func moreOptionTapped() {
        showMoreOptions()
    }
    
    
    private func showMoreOptions() {
        let actionSheet = UIAlertController(title: Constants.Button.moreOptions, message: nil, preferredStyle: .actionSheet)
        let updateProject = UIAlertAction(title: Constants.Button.updateProject, style: .default) { action in
            self.coordinator?.updateProject(self.projectReaderPresenter.selectedProject, self.projectReaderPresenter.userData)
        }
        let deleteProject = UIAlertAction(title: Constants.Button.deleteProject, style: .destructive) { (action) in
            self.setConfirmationDialog()
        }
        
        let cancel = UIAlertAction(title: Constants.Button.cancel, style: .cancel, handler: nil)
        
        let actionArry = [updateProject, deleteProject, cancel]
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
    
    private func setRightButtonInTextField() {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: Constants.Image.plusCircle)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: -6, left: -21, bottom: -6, right: 5)
        button.frame = CGRect(x: CGFloat(taskTextField.frame.size.width - 25), y: CGFloat(0), width: CGFloat(50), height: CGFloat(50))
        button.setImage( image, for: .normal)
        
        button.addTarget(self, action: #selector(self.addTask), for: .touchUpInside)
        taskTextField.rightView = button
        taskTextField.rightViewMode = .always
    }
    #warning("Add task Creation here")
    @objc func addTask() {
//        if projectReaderPresenter.checkTaskTitle(taskTextField.text) {
//            self.projectReaderPresenter.updateProject(taskTextField.text)
//            DispatchQueue.main.async {
//                self.taskTableView.reloadData()
//            }
//            //Do something
//        } else {
//            //Error
//
//        }
    }
    
    func configureViewController() {
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
            self.coverImage.kf.setImage(with: url, placeholder: UIImage(named: Constants.Image.cover), options: nil, completionHandler: nil)
        }
        
        if projectReaderPresenter.checkIfDescriptionIsEmpty() {
            self.descriptionContentView.isHidden = true
        } else {
            self.descriptionContentView.isHidden = false
            self.descriptionTextView.text = project.description
        }
        
//        if projectReaderPresenter.checkIfTaskListIsEmpty() {
//            self.taskTableView.isHidden = true
//        } else {
        self.taskTableView.isHidden = false
//        }
        
        self.guestContentView.isHidden = true
    }
    
    private func registerCell() {
        let nib = UINib(nibName: Constants.Cell.taskCell, bundle: nil)
        taskTableView.register(nib, forCellReuseIdentifier: Constants.Cell.taskCell)
    }
    
    private func setConfirmationDialog() {
        let confirmationDialog = UIAlertController(title: Constants.Button.deleteMessage, message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: Constants.Button.yes, style: .destructive) { action in
            self.showLoader()
            self.projectReaderPresenter.deleteProject()
        }
        
        let cancel = UIAlertAction(title: Constants.Button.cancel, style: .cancel, handler: nil)
        
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
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayNewData), name: NSNotification.Name(Constants.Notification.childEnd), object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(Constants.Notification.childEnd), object: nil)
    }
    
    @objc func displayNewData() {
        
        projectReaderPresenter.refreshCurrentProject()
    }
}
