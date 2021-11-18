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
        setupViewController()
    }
    
    private func setupViewController() {
        setupTaskEditor()
        if taskCreationPresenter.isTaskReader() {
            //Case is reader == True
            //Display task Data
            //Disable editing
            self.displayTaskData()
            self.canUserEdit(autorization: false)
        } else {
            //Case is reader == False
            //Display task Creation
            //Allow Editing
            self.canUserEdit(autorization: true)
        }
    }
    
    private func setupTaskEditor() {
        setDelegate()
        displayDefaultTaskData()
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
        if taskCreationPresenter.isTaskReader() {
            setRightBarEditButton()
        } else {
            setRightBarSaveButton()
        }
    }
    
    private func displayDefaultTaskData() {
        self.titleTextField.text = taskCreationPresenter.task?.title
        if taskCreationPresenter.task?.commentary != "" && taskCreationPresenter.task?.commentary != nil {
            self.commentaryTextView.text = taskCreationPresenter.task?.commentary
        } else {
            setTextViewPlaceHolder()
        }
        
    }
    
    private func setRightBarSaveButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save task", style: .plain, target: self, action: #selector(saveTask))
    }
    
    private func setRightBarEditButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTask))
    }
    
    @objc func saveTask() {
        guard let task = taskCreationPresenter.task else {return}
        
        taskCreationPresenter.updateTask(with: task.title, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: datePicker.date)
    }
    
    
    
    @objc func editTask(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            canUserEdit(autorization: true)
            sender.title = "Perform Change"
        } else {
            sender.title = "Edit"
            
            guard let task = taskCreationPresenter.task else {return}
            
            taskCreationPresenter.updateTask(with: task.title, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: datePicker.date)
        }
    }
    
    private func canUserEdit(autorization: Bool) {
        titleTextField.isUserInteractionEnabled = autorization
        locationTextField.isUserInteractionEnabled = autorization
        prioritySwitch.isUserInteractionEnabled = autorization
        datePicker.isUserInteractionEnabled = autorization
        commentaryTextView.isUserInteractionEnabled = autorization
    }
    
    private func displayTaskData() {
        guard let task = taskCreationPresenter.task, let priority = task.priority else {
            return
        }
        if task.location != "" && task.location != nil {
            self.locationTextField.text = task.location
        } else {
            self.locationTextField.text = "No location"
            self.locationTextField.textColor = .placeholderText
        }
        self.prioritySwitch.isOn = priority
        if task.deadLine != nil {
            #warning("Always display date, see to optionnal picker ")
            guard let date = task.deadLine else {return}
            datePicker.setDate(date, animated: true)
        } else {
            self.datePicker.isHidden = true
        }
        if task.commentary != "" {
            self.commentaryTextView.text = task.commentary
        } else {
            self.commentaryTextView.isHidden = true 
        }
    }
}



