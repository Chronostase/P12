//
//  ProjectCreationViewController.swift
//  Unsinkable
//
//  Created by Thomas on 13/01/2021.
//

import UIKit

class ProjectCreationViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?

    @IBOutlet var projectNameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var coverStackView: UIStackView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var calendarSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        projectNameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async {
            self.projectNameTextField.removeLeftAndRightBorder()
        }
    }
}
