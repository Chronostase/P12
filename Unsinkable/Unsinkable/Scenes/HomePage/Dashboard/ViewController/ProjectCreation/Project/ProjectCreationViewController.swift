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
    @IBOutlet var projectTextView: UITextView!
    @IBOutlet var taskTextField: CustomTextField!
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var finishButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setDelegateAndDataSource()
        setRightButtonInTextField()
        addRightNavigationBarButton()
    }
    
    @IBAction func finishButton(_ sender: Any) {
        projectCreationPresenter.registerProject(projectTextField.text, projectTextView.text)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async {
            self.setUpUI()
        }
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
        
    }
    
    private func addRightNavigationBarButton() {
        guard let image = UIImage(systemName: "ellipsis") else {
            return 
        }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showMoreOptions))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func showMoreOptions() {
    }
    
    private func setUpUI() {
        finishButton.setTitle("Finish", for: .normal)
    }
}
