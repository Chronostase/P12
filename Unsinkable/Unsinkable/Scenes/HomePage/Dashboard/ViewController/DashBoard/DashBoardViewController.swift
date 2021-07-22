//
//  DashBoardViewController.swift
//  Unsinkable
//
//  Created by Thomas on 06/01/2021.
//

import UIKit

class DashBoardViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    lazy var dashBoardPresenter = {
        return DashBoardPresenter()
    }()
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func profilButton(_ sender: UIButton) {
        coordinator?.profil()
    }
    
    @IBAction func addProject(_ sender: Any) {
        coordinator?.projectCreation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dashBoardPresenter.getUserData()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dashBoardPresenter.getCurrentDate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupCollectionView() {
        setDelegateAndDataSource()
        setupCustomCell()
    }
    
    private func setupCustomCell() {
        let nib = UINib(nibName: "ProjectCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProjectCell")
    }
    
    private func setDelegateAndDataSource() {
        self.dashBoardPresenter.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self 
    }
    
    func updateDateLabel(_ date: String) {
        self.dateLabel.text = date
    }
    
    func showLoader() {
        let loadingVC = LoaderViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        navigationController?.present(loadingVC, animated: true, completion: nil)
    }
    
}
