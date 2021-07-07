//
//  TaskCreationViewController.swift
//  Unsinkable
//
//  Created by Thomas on 02/07/2021.
//

import Foundation
import UIKit

class TaskCreationViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator? 
    
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var taskCreationTextField: CustomTextField!
    @IBOutlet var taskLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setRightButtonInTextField()
        }
    }
    
    private func setDelegate() {
        taskCreationTextField.delegate = self
        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
    
    private func setRightButtonInTextField() {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "plus.circle.fill")
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: -6, left: -21, bottom: -6, right: 5)
        button.frame = CGRect(x: CGFloat(taskCreationTextField.frame.size.width - 25), y: CGFloat(0), width: CGFloat(50), height: CGFloat(50))
        button.setImage( image, for: .normal)
        
        button.addTarget(self, action: #selector(self.addTask), for: .touchUpInside)
        taskCreationTextField.rightView = button
        taskCreationTextField.rightViewMode = .always
    }
    
    @objc func addTask() {
        
    }
}
