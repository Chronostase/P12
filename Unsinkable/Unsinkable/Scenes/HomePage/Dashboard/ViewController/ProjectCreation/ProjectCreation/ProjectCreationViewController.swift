//
//  ProjectCreationViewController.swift
//  Unsinkable
//
//  Created by Thomas on 13/01/2021.
//

import UIKit

class ProjectCreationViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    lazy var projectCreationPresenter = {
        return ProjectCreationPresenter()
    }()
    
    @IBOutlet var projectLabel: UILabel!
    @IBOutlet var projectTextField: CustomTextField!
    @IBOutlet var taskTextField: CustomTextField!
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var projectTextView: UITextView!
    @IBOutlet var finishButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var locationView: UIView!
    @IBOutlet var deadLineView: UIView!
    @IBOutlet var usersView: UIView!
    @IBOutlet var projectContainer: UIView!
    @IBOutlet var customProjectView: UIView!
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var coverImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.navigationController?.navigationBar.isHidden = false
        setupCustomCell()
        configureFakeProject()
        setDelegateAndDataSource()
        addTextViewDoneButton()
        setRightButtonInTextField()
        addRightNavigationBarButton()
    }
    
    #warning("Take Image from ImageView transform it to data")
    @IBAction func finishButton(_ sender: Any) {
        guard let imageData = coverImage.image?.jpegData(compressionQuality: 1.0) else {
            return
        }
        projectCreationPresenter.registerProject(projectTextField.text, projectTextView.text, imageData)
    }
    
    @IBAction func addCoverPicture(_ sender: UIButton) {
        imagePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async {
            self.setUpUI()
        }
    }
    
    private func configureFakeProject() {
        coverImageButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 85, bottom: 15, right: 85 )
        customProjectView.layer.masksToBounds = true
        customProjectView.layer.cornerRadius = 8
    }
    
    private func addTextViewDoneButton() {
        projectTextView.addDoneButton(title: "Done", target: self, selector: #selector (tapDone(sender:)))
    }
    
    @objc private func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    private func setDelegateAndDataSource() {
        taskTextField.delegate = self
        projectTextField.delegate = self
        taskTableView.dataSource = self
        taskTableView.delegate = self
        projectCreationPresenter.delegate = self 
    }
    
    private func setRightButtonInTextField() {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "plus.circle.fill")
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
    
    @objc func addTask() {
        // Check if user type something, take it set it to cell title -> add cell to table view
        if projectCreationPresenter.checkTastTitle(taskTextField.text) {
            self.projectCreationPresenter.updateProject(taskTextField.text)
            DispatchQueue.main.async {
                self.taskTableView.reloadData()
            }
            //Do something
        } else {
            //Error
            
        }
    }
    
    private func addRightNavigationBarButton() {
        guard let image = UIImage(systemName: "ellipsis") else {
            return 
        }
//        let button = UIButton(type: .system)
//        button.setImage(image, for: .normal)
//
//        let barButton = UIBarButtonItem(customView: button)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(moreOptionTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func moreOptionTapped() {
        showMoreOptions()
    }
    
    private func showMoreOptions() {
        let actionSheet = UIAlertController(title: "More Options", message: nil, preferredStyle: .actionSheet)
        let coverPicture = UIAlertAction(title: "Choose a cover", style: .default) { (action) in
            
            self.imagePicker()
        }
        
        let deadLine = UIAlertAction(title: "DeadLine", style: .default) { (action) in
            
            print("DeadLine Option Tapped")
        }
        
        let addUsers = UIAlertAction(title: "Add User To Project", style: .default) { (action) in
            
            print("Add Users Option Tapped")
        }
        
        let deleteProject = UIAlertAction(title: "Delete Project", style: .destructive) { (action) in
            
            print("Delete Project Option Tapped")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionArry = [coverPicture, deadLine, addUsers, deleteProject, cancel]
        for action in actionArry {
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func imagePicker() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setUpUI() {
        finishButton.setTitle("Finish", for: .normal)
    }
    
    private func setupCustomCell() {
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        taskTableView.register(nib, forCellReuseIdentifier: "TaskCell")
    }
}

extension ProjectCreationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.popViewController(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        coverImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
