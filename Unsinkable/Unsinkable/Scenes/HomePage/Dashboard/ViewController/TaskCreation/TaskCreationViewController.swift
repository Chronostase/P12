//
//  TaskCreationViewController.swift
//  Unsinkable
//
//  Created by Thomas on 13/10/2021.
//

import Foundation
import UIKit

class TaskCreationViewController: UIViewController {
    
    // MARK: Properties
    weak var coordinator: HomeCoordinator?
    lazy var taskCreationPresenter = {
        return TaskCreationPresenter()
    }()
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var prioritySwitch: UISwitch!
    @IBOutlet var deadLineSwitch: UISwitch!
    @IBOutlet var deadLineView: UIView!
    @IBOutlet var deadLineSeparatorView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var commentaryTextView: UITextView!
    @IBOutlet var deleteTaskButton: UIButton!
    
    //MARK: Methods
    @IBAction func deadLineSwitch(_ sender: UISwitch) {
        if deadLineSwitch.isOn {
            isDeadLineViewIsNeeded(true)
        } else {
            isDeadLineViewIsNeeded(false)
        }
        
    }
    @IBAction func datePicker(_ sender: UIDatePicker) {
    }
    @IBAction func deleteTaskButton(_ sender: UIButton) {
        setConfirmationDialog()
    }
    
    override func viewDidLoad() {
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
    }
    
    //MARK: Setup Methods
    
    private func setupViewController() {
        setupTaskEditor()
        if taskCreationPresenter.isTaskReader() {
            self.taskCreationPresenter.delegate = self
            //Task reader
            self.displayTaskData()
            self.setDeleteTaskButon()
            self.canUserEdit(autorization: false)
        } else {
            //Task Creation
            self.displayTaskData()
            self.canUserEdit(autorization: true)
        }
    }
    
    private func setupTaskEditor() {
        setDelegate()
        displayDefaultTaskData()
        setNavigationBar()
        setupDeadLineView()
    }
    
    private func setDelegate() {
        self.commentaryTextView.delegate = self
        self.titleTextField.delegate = self
        self.locationTextField.delegate = self
    }
    
    private func displayDefaultTaskData() {
        self.titleTextField.text = taskCreationPresenter.task?.title
        if taskCreationPresenter.task?.commentary != "" && taskCreationPresenter.task?.commentary != nil {
            self.commentaryTextView.text = taskCreationPresenter.task?.commentary
        } else {
            setTextViewPlaceHolder()
        }
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        if taskCreationPresenter.isTaskReader() {
            setRightBarEditButton()
        } else {
            setRightBarSaveButton()
        }
    }
    
    private func setupDeadLineView() {
        if taskCreationPresenter.isDeadLineViewNeeded() {
            self.deadLineView.isHidden = false
        } else {
            self.deadLineView.isHidden = true 
        }
    }
    
    //MARK: Set Button Methods
    
    private func setRightBarSaveButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Button.saveTask, style: .plain, target: self, action: #selector(saveTask))
    }
    
    private func setRightBarEditButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Button.edit, style: .plain, target: self, action: #selector(editTask))
    }
    
    private func setDeleteTaskButon() {
        if taskCreationPresenter.isDeleteTaskNeeded() {
            self.deleteTaskButton.isHidden = false
        } else {
            self.deleteTaskButton.isHidden = true
        }
    }
    
    @objc func editTask(_ sender: UIBarButtonItem) {
        if sender.title == Constants.Button.edit {
            canUserEdit(autorization: true)
            sender.title = Constants.Button.performChange
        } else {
            sender.title = Constants.Button.edit
            canUserEdit(autorization: false)
            if deadLineSwitch.isOn {
                taskCreationPresenter.updateTask(with: titleTextField.text, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: datePicker.date)
            } else {
                taskCreationPresenter.updateTask(with: titleTextField.text, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: nil)
                
            }
        }
    }
    
    @objc func saveTask() {
        guard let task = taskCreationPresenter.task else {return}
        if deadLineSwitch.isOn {
            taskCreationPresenter.updateLocalTask(with: task.title, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: datePicker.date)
        } else {
            taskCreationPresenter.updateLocalTask(with: task.title, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: nil)
        }
    }
    
    private func canUserEdit(autorization: Bool) {
        titleTextField.isUserInteractionEnabled = autorization
        locationTextField.isUserInteractionEnabled = autorization
        prioritySwitch.isUserInteractionEnabled = autorization
        deadLineSwitch.isUserInteractionEnabled = autorization
        datePicker.isUserInteractionEnabled = autorization
        commentaryTextView.isUserInteractionEnabled = autorization
    }
    
    private func setTextViewPlaceHolder() {
        commentaryTextView.text = Constants.Label.commentaryPlaceHolder
        commentaryTextView.textColor = .placeholderText
    }
    
    private func displayTaskData() {
        guard let task = taskCreationPresenter.task, let priority = task.priority else {
            return
        }
        if task.location != "" && task.location != nil {
            self.locationTextField.text = task.location
        } else {
            self.locationTextField.text = Constants.Label.locationPlaceHolder
            self.locationTextField.textColor = .placeholderText
        }
        self.prioritySwitch.isOn = priority
        if task.deadLine != nil {
            self.deadLineSwitch.isOn = true
            isDeadLineViewIsNeeded(true)
            guard let date = task.deadLine else {return}
            datePicker.setDate(date, animated: true)
        } else {
            isDeadLineViewIsNeeded(false)
        }
        if task.commentary != "" {
            if task.commentary == Constants.Label.commentaryPlaceHolder {
                self.commentaryTextView.text = task.commentary
                self.commentaryTextView.textColor = .placeholderText
            } else {
                self.commentaryTextView.text = task.commentary
            }
        } else {
            self.commentaryTextView.isHidden = true 
        }
    }
    
    private func isDeadLineViewIsNeeded(_ statement: Bool) {
        self.deadLineView.isHidden = !statement
        self.datePicker.isHidden = !statement
    }
    
    private func setConfirmationDialog() {
        let confirmationDialog = UIAlertController(title: Constants.Button.deleteMessage, message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: Constants.Button.yes, style: .destructive) { action in
            self.taskCreationPresenter.deleteTask()
        }
        
        let cancel = UIAlertAction(title: Constants.Button.cancel, style: .cancel, handler: nil)
        
        let actionArray = [delete, cancel]
        
        for action in actionArray {
            confirmationDialog.addAction(action)
        }
        present(confirmationDialog, animated: true, completion: nil)
    }
}



