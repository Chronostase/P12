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
    //Check if deadLineSwitch is one if it is show deadLineView else hidde
    @IBAction func deadLineSwitch(_ sender: UISwitch) {
        if deadLineSwitch.isOn {
            isDeadLineViewIsNeeded(true)
        } else {
            isDeadLineViewIsNeeded(false)
        }
        
    }
    @IBAction func datePicker(_ sender: UIDatePicker) {}
    
    //Show confirmation dialog befor deleting task
    @IBAction func deleteTaskButton(_ sender: UIButton) {
        setConfirmationDialog()
    }
    
    override func viewDidLoad() {
        setupViewController()
    }
    
    //Do additional setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
    }
    
    //MARK: Setup Methods
    
    //Check if ViewController is in creation mode or reader and setup it
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
    
    //Default setting for viewController
    private func setupTaskEditor() {
        setDelegate()
        displayDefaultTaskData()
        setNavigationBar()
        setupDeadLineView()
    }
    
    //Set item delegate to self
    private func setDelegate() {
        self.commentaryTextView.delegate = self
        self.titleTextField.delegate = self
        self.locationTextField.delegate = self
    }
    
    //Display default task settings
    private func displayDefaultTaskData() {
        self.titleTextField.text = taskCreationPresenter.task?.title
        if taskCreationPresenter.task?.commentary == Constants.Label.commentaryPlaceHolder {
            self.commentaryTextView.textColor = .placeholderText
        }
        if taskCreationPresenter.task?.commentary != "" && taskCreationPresenter.task?.commentary != nil {
            self.commentaryTextView.text = taskCreationPresenter.task?.commentary
        } else {
            setTextViewPlaceHolder()
        }
    }
    
    //Set right bar button to save or edit if taskCreation is in reader or editor mode
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        if taskCreationPresenter.isTaskReader() {
            setRightBarEditButton()
        } else {
            setRightBarSaveButton()
        }
    }
    
    //If DeadLineViewIsNeeded show deadline view else hidde
    private func setupDeadLineView() {
        if taskCreationPresenter.isDeadLineViewNeeded() {
            self.deadLineView.isHidden = false
        } else {
            self.deadLineView.isHidden = true 
        }
    }
    
    //MARK: Set Button Methods
    
    //Create rightNavigationBar save button
    private func setRightBarSaveButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Button.saveTask, style: .plain, target: self, action: #selector(saveTask))
    }
    
    //Create rightNavigationBar edit button
    private func setRightBarEditButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Button.edit, style: .plain, target: self, action: #selector(editTask))
    }
    
    //Allow only projectOwner to delete task 
    private func setDeleteTaskButon() {
        if taskCreationPresenter.isDeleteTaskNeeded() {
            self.deleteTaskButton.isHidden = false
        } else {
            self.deleteTaskButton.isHidden = true
        }
    }
    
    //Allow to edit / save task
    @objc func editTask(_ sender: UIBarButtonItem) {
        if sender.title == Constants.Button.edit {
            canUserEdit(autorization: true)
            sender.title = Constants.Button.performChange
        } else {
            sender.title = Constants.Button.edit
            canUserEdit(autorization: false)
            self.showLoader()
            if deadLineSwitch.isOn {
                taskCreationPresenter.updateTask(with: titleTextField.text, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: datePicker.date)
            } else {
                taskCreationPresenter.updateTask(with: titleTextField.text, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: nil)
                
            }
        }
    }
    
    //Update local task with task data
    @objc func saveTask() {
        guard let task = taskCreationPresenter.task else {return}
        if deadLineSwitch.isOn {
            taskCreationPresenter.updateLocalTask(with: task.title, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: datePicker.date)
        } else {
            taskCreationPresenter.updateLocalTask(with: task.title, location: locationTextField.text, priority: prioritySwitch.isOn, commentary: commentaryTextView.text, deadLine: nil)
        }
    }
    
    //Enable or disable edit mode
    private func canUserEdit(autorization: Bool) {
        titleTextField.isUserInteractionEnabled = autorization
        locationTextField.isUserInteractionEnabled = autorization
        prioritySwitch.isUserInteractionEnabled = autorization
        deadLineSwitch.isUserInteractionEnabled = autorization
        datePicker.isUserInteractionEnabled = autorization
        commentaryTextView.isUserInteractionEnabled = autorization
    }
    
    //Add textView placeHolder
    private func setTextViewPlaceHolder() {
        commentaryTextView.text = Constants.Label.commentaryPlaceHolder
        commentaryTextView.textColor = .placeholderText
    }
    
    //Display task data to fields
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
        if task.commentary == Constants.Label.commentaryPlaceHolder {
            self.commentaryTextView.text = task.commentary
            self.commentaryTextView.textColor = .placeholderText
        } else {
            self.commentaryTextView.text = task.commentary
        }
    }
    
    //Check if deadLine view is needed
    private func isDeadLineViewIsNeeded(_ statement: Bool) {
        self.deadLineView.isHidden = !statement
        self.datePicker.isHidden = !statement
    }
    
    //Show confirmationDialog to user before sensitive operation 
    private func setConfirmationDialog() {
        let confirmationDialog = UIAlertController(title: Constants.Button.deleteMessage, message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: Constants.Button.yes, style: .destructive) { action in
            self.showLoader()
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



