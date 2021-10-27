//
//  TaskCreationViewController.swift
//  Unsinkable
//
//  Created by Thomas on 13/10/2021.
//

import Foundation
import UIKit

#warning("Manage reader / editor display")
class TaskCreationViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    lazy var taskCreationPresenter = {
        return TaskCreationPresenter()
    }()
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var prioritySwitch: UISwitch!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var commentaryTextView: UITextView!
    
    @IBAction func prioritySwitch(_ sender: UISwitch) {
    }
    @IBAction func datePicker(_ sender: UIDatePicker) {
    }
    
    override func viewDidLoad() {
        setupTaskEditor()
    }
    
    private func setupTaskReader() {
        setDelegate()
        displayTaskData()
    }
    
    private func setupTaskEditor() {
        setDelegate()
        setupTaskInformation()
        setTextViewPlaceHolder()
        setNavigationBar()
    }
    
    private func setDelegate() {
        self.commentaryTextView.delegate = self
        self.titleTextField.delegate = self
        self.locationTextField.delegate = self
    }
    
    private func setTextViewPlaceHolder() {
        commentaryTextView.text = "Commentary"
        commentaryTextView.textColor = .placeholderText
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        setRightBarButton()
    }
    
    private func displayTaskData() {
        self.titleTextField.text = taskCreationPresenter.task?.title
        if taskCreationPresenter.task?.commentary != "" {
            self.commentaryTextView.text = taskCreationPresenter.task?.commentary
        } else {
            setTextViewPlaceHolder()
        }
        
    }
    
    private func setupTaskInformation() {
        self.titleTextField.text = taskCreationPresenter.task?.title
    }
    
    
    private func setRightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save task", style: .plain, target: self, action: #selector(saveTask))
    }
    
    @objc func saveTask() {
        guard let task = taskCreationPresenter.task else {return}
        
        taskCreationPresenter.updateTask(with: task.title, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: "\(datePicker.date)")
        
    }
}



