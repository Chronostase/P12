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
    @IBOutlet var personalCollectionView: UICollectionView!
    @IBOutlet var professionalCollectionView: UICollectionView!
    
    @IBAction func profilButton(_ sender: UIButton) {
        coordinator?.profil()
    }
    
    @IBAction func addPersonalProject(_ sender: Any) {
        coordinator?.projectCreation(isPersonal: true)
    }
    
    @IBAction func addProfessionalProject(_ sender: Any) {
        coordinator?.projectCreation(isPersonal: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    private func loadData() {
        dashBoardPresenter.getUserData()
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
        personalCollectionView.register(nib, forCellWithReuseIdentifier: "ProjectCell")
        let xib = UINib(nibName: "ProjectCell", bundle: nil)
        professionalCollectionView.register(xib, forCellWithReuseIdentifier: "ProjectCell")
    }
    
    private func setDelegateAndDataSource() {
        self.dashBoardPresenter.delegate = self
        self.personalCollectionView.delegate = self
        self.personalCollectionView.dataSource = self
        self.professionalCollectionView.delegate = self
        self.professionalCollectionView.dataSource = self 
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
