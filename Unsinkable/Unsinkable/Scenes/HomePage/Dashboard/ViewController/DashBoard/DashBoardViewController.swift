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
        coordinator?.profil(dashBoardPresenter.data)
    }
    
    @IBAction func addPersonalProject(_ sender: Any) {
        coordinator?.projectCreation(isPersonal: true, dashBoardPresenter.data)
    }
    
    @IBAction func addProfessionalProject(_ sender: Any) {
        coordinator?.projectCreation(isPersonal: false, dashBoardPresenter.data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dashBoardPresenter.getCurrentDate()
        loadData()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false 
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        loadData()
    }
    
    private func loadData() {
        dashBoardPresenter.getUserData()
        reloadCollection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    private func setupCollectionView() {
        setDelegateAndDataSource()
        setupCustomCell()
    }
    
    private func setupCustomCell() {
        let nib = UINib(nibName: Constants.Cell.projectCell, bundle: nil)
        personalCollectionView.register(nib, forCellWithReuseIdentifier: Constants.Cell.projectCell)
        let xib = UINib(nibName: Constants.Cell.projectCell, bundle: nil)
        professionalCollectionView.register(xib, forCellWithReuseIdentifier: Constants.Cell.projectCell)
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
    
    private func reloadCollection() {
        self.personalCollectionView.reloadData()
        self.professionalCollectionView.reloadData()
    }
    
    func showLoader() {
        let loadingVC = LoaderViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        navigationController?.present(loadingVC, animated: true, completion: nil)
    }
    
}
