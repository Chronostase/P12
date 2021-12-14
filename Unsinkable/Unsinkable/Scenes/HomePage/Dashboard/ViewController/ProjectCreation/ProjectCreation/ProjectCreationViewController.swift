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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Enter IN ViewDIDDISAPPEAR ")
    }
    
    private func setup() {
        self.navigationController?.navigationBar.isHidden = false
        setupCustomCell()
        configureFakeProject()
        setDelegateAndDataSource()
        addTextViewDoneButton()
        setRightButtonInTextField()
//        addRightNavigationBarButton()
        hideMoreDetail()
    }
    
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
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async {
            self.setUpUI()
        }
    }
    
    private func hideMoreDetail() {
        locationView.isHidden = true
        deadLineView.isHidden = true
        usersView.isHidden = true
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
        //Update project, register a task With title in projectPresenter.task
        if projectCreationPresenter.checkTaskTitle(taskTextField.text) {
            self.projectCreationPresenter.updateProject(taskTextField.text)
            DispatchQueue.main.async {
                self.taskTableView.reloadData()
            }
            //Do something
        } else {
            //Error
            
        }
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
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        coverImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
