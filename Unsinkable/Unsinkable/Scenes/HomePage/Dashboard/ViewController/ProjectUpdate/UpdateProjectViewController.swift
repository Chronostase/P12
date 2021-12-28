//
//  UpdateProjectViewController.swift
//  Unsinkable
//
//  Created by Thomas on 28/12/2021.
//

import UIKit

class UpdateProjectViewController: UIViewController {
    weak var coordinator: HomeCoordinator?
    
    lazy var updateProjectPresenter = {
        return UpdateProjectPresenter()
    }()
    @IBOutlet var backGroundView: UIView!
    @IBOutlet var projectTilteTextField: CustomTextField!
    @IBOutlet var projectDescriptionTextView: UITextView!
    @IBOutlet var selectCoverButton: UIButton!
    
    @IBAction func selectCoverButton(_ sender: UIButton) {
        imagePicker()
    }
    
    @IBAction func updateProjectButton(_ sender: UIButton) {
        updateProject()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        print(self.navigationController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notifyParent()
    }
    
    private func setupViewController() {
        setupDelegateAndDate()
        setupVisualEffect()
        addDoneButton()
    }
    
    private func setupDelegateAndDate() {
        self.updateProjectPresenter.delegate = self
        self.projectTilteTextField.delegate = self
        self.projectDescriptionTextView.delegate = self
        self.projectTilteTextField.text = updateProjectPresenter.currentProject?.title
        self.projectDescriptionTextView.text = updateProjectPresenter.currentProject?.description
    }
    
    private func addDoneButton() {
        projectDescriptionTextView.addDoneButton(title: "Done", target: self, selector: #selector (tapDone(sender:)))
    }
    
    @objc private func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    private func setupVisualEffect() {
        self.backGroundView.backgroundColor = .clear
        self.backGroundView.isOpaque = false
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backGroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backGroundView.insertSubview(blurEffectView, at: 0)
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
    
    
    private func updateProject() {
        showLoader()
        updateProjectPresenter.updateLocalData(projectTilteTextField.text, projectDescriptionTextView.text)
        updateProjectPresenter.updateProject()
    }
    
    private func notifyParent() {
        NotificationCenter.default.post(name: NSNotification.Name("ChildEnd"), object: nil)
    }
    
    private func showLoader() {
        let loaderVC = LoaderViewController()
        loaderVC.modalPresentationStyle = .overCurrentContext
        loaderVC.modalTransitionStyle = .crossDissolve
        self.present(loaderVC, animated: true, completion: nil)
    }
    
}

extension UpdateProjectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        updateProjectPresenter.coverData = image.jpegData(compressionQuality: 0.25)
        picker.dismiss(animated: true, completion: nil)
    }
}
