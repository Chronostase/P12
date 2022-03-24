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
    @IBOutlet var contentView: CustomView!
    @IBOutlet var backGroundView: UIView!
    @IBOutlet var projectTilteTextField: CustomTextField!
    @IBOutlet var projectDescriptionTextView: UITextView!
    @IBOutlet var selectCoverButton: UIButton!
    
    //Show ImagePicker to update project cover picture
    @IBAction func selectCoverButton(_ sender: UIButton) {
        imagePicker()
    }
    
    //Save updated project
    @IBAction func updateProjectButton(_ sender: UIButton) {
        updateProject()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    //Notify project reader that update is ended
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notifyParent()
    }
    
    //Setup ViewController
    private func setupViewController() {
        setupDelegateAndData()
        setupTapGesture()
        setupVisualEffect()
        addDoneButton()
    }
    
    //Set item delegate to self and display data
    private func setupDelegateAndData() {
        self.updateProjectPresenter.delegate = self
        self.projectTilteTextField.delegate = self
        self.projectDescriptionTextView.delegate = self
        self.projectTilteTextField.text = updateProjectPresenter.currentProject?.title
        self.projectDescriptionTextView.text = updateProjectPresenter.currentProject?.description
    }
    
    //Add done button to textView
    private func addDoneButton() {
        projectDescriptionTextView.addDoneButton(title: Constants.Button.done, target: self, selector: #selector (tapDone(sender:)))
    }
    
    //Resign textView
    @objc private func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    //Setup baground blur
    private func setupVisualEffect() {
        self.backGroundView.backgroundColor = .clear
        self.backGroundView.isOpaque = false
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backGroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backGroundView.insertSubview(blurEffectView, at: 0)
    }
    
    //Present image picker
    private func imagePicker() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Show loader and update local and remote data
    private func updateProject() {
        showLoading()
        updateProjectPresenter.updateLocalData(projectTilteTextField.text, projectDescriptionTextView.text)
        updateProjectPresenter.updateProject()
    }
    
    //Notify reader update end
    private func notifyParent() {
        NotificationCenter.default.post(name: NSNotification.Name(Constants.Notification.childEnd), object: nil)
    }
    
    //Add tap gesture to backGround view (Blur view)
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        backGroundView.isUserInteractionEnabled = true
        self.backGroundView.addGestureRecognizer(tapGesture)
        
    }
    
    //Dismiss ProjectUpdateVC
    @objc private func didTapGesture(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Show loader
    private func showLoading() {
        let loaderVC = LoaderViewController()
        loaderVC.modalPresentationStyle = .overCurrentContext
        loaderVC.modalTransitionStyle = .crossDissolve
        self.present(loaderVC, animated: true, completion: nil)
    }
    
    //Show error if update project failed
    func showUpdateAlert(_ title: String,_ message: String? = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}


extension UpdateProjectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Set selectedPicture to coverData, dismiss imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        updateProjectPresenter.coverData = image.jpegData(compressionQuality: 0.25)
        picker.dismiss(animated: true, completion: nil)
    }
}
