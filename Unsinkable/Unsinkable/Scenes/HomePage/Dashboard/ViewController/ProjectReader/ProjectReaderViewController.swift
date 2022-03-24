//
//  ProjectReaderViewController.swift
//  Unsinkable
//
//  Created by Thomas on 29/09/2021.
//

import Foundation
import Kingfisher
import UIKit
import IQKeyboardManagerSwift

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
    @IBOutlet var contentTitleView: UIView!
    
    lazy var projectReaderPresenter = {
        return ProjectReaderPresenter()
    }()
    
    //Add observer to notify when project is update
    override func viewDidLoad() {
        setup()
        addObserver()
    }
    //Refresh current project and do additional setup
    override func viewWillAppear(_ animated: Bool) {
        projectReaderPresenter.refreshCurrentProject()
        isKeyboardAnimationNeeded(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isKeyboardAnimationNeeded(false)
        self.removeObserver()
    }
    
    //Futur features in comming
    @IBAction func showMoreButton(_ sender: UIButton) {
    }
    
    func setup() {
        setDelegate()
        registerCell()
        setContentTitleViewUI()
        configureViewController()
        setRightButtonInTextField()
        addRightNavigationBarButton()
    }
    
    //Set UI for contentTitle View
    private func setContentTitleViewUI() {
        self.contentTitleView.backgroundColor = UIColor.darkGray
        self.contentTitleView.layer.cornerRadius = 8
        self.contentTitleView.layer.borderWidth = 0.3
        self.contentTitleView.layer.borderColor = UIColor.white.cgColor
    }
    
    //Add right navigation bar button to delete or update project
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
    
    //Set actionSheet to update or delete after a confirmationDialog
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
    
    //Set item delegate to self
    private func setDelegate() {
        self.projectReaderPresenter.delegate = self 
        self.taskTableView.dataSource = self
        self.taskTableView.delegate = self 
    }
    
    //Set textField rightButton to add task
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
    
    //Add task to current project
    @objc func addTask() {
        if projectReaderPresenter.checkTaskTitle(taskTextField.text) {
            guard let title = taskTextField.text else {return}
            self.showLoader()
            self.projectReaderPresenter.addNewTask(title)
            DispatchQueue.main.async {
                self.taskTextField.text = nil
                self.taskTextField.placeholder = Constants.Label.addTaskHolder
                self.taskTableView.reloadData()
            }
        } else {
            self.taskTextField.text = nil
            self.taskTextField.placeholder = Constants.Error.ProjectCreation.setTaskTitle
        }
    }
    
    //Configure VC and set Image place holder with kingFisher
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
            self.descriptionTextView.isEditable = false
            self.descriptionTextView.isScrollEnabled = true
            self.descriptionTextView.text = project.description
        }
        self.taskTableView.isHidden = false
        self.guestContentView.isHidden = true
    }
    
    //Register task cell
    private func registerCell() {
        let nib = UINib(nibName: Constants.Cell.taskCell, bundle: nil)
        taskTableView.register(nib, forCellReuseIdentifier: Constants.Cell.taskCell)
    }
    
    //Configure confirmationDialog before project erase
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
    
    //Observer to notify when project is update
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayNewData), name: NSNotification.Name(Constants.Notification.childEnd), object: nil)
    }
    
    //Remove observer
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(Constants.Notification.childEnd), object: nil)
    }
    
    //Refresh project with newData
    @objc func displayNewData() {
        projectReaderPresenter.refreshCurrentProject()
    }
    
    //Enable or disable IQKeyboardManager
    private func isKeyboardAnimationNeeded(_ authorization: Bool) {
        IQKeyboardManager.shared.enable = authorization
    }
}
