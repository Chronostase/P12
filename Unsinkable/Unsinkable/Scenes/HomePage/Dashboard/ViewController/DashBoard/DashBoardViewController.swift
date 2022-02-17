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
    
    
    
    @IBOutlet var personalEmptyView: EmptyView!
    @IBOutlet var professionalEmptyView: EmptyView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
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
        setupViewController()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isTabBarEnable(false)
        reloadSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.showLoader()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func reloadSettings() {
        dashBoardPresenter.getCurrentDate()
        loadData()
        searchBar.text = ""
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        
    }
    private func loadData() {
        dashBoardPresenter.getUserData()
        reloadCollection()
    }
    
    private func setupViewController() {
        setupCollectionView()
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
        self.searchBar.delegate = self
        self.dashBoardPresenter.delegate = self
        self.personalCollectionView.delegate = self
        self.personalCollectionView.dataSource = self
        self.professionalCollectionView.delegate = self
        self.professionalCollectionView.dataSource = self 
    }
    
    func updateDateLabel(_ date: String) {
        self.dateLabel.text = date
    }
    
    func reloadCollection() {
        self.personalCollectionView.reloadData()
        self.professionalCollectionView.reloadData()
    }
    
    
    func setupEmptyView(_ projects: [Project]?, _ collectionView: UICollectionView) {
        
        if let projectList = projects {
            if projectList.isEmpty {
                self.isEmptyViewNeededFor(collectionView, true)
            } else {
                self.isEmptyViewNeededFor(collectionView, false)
            }
        } else {
            self.isEmptyViewNeededFor(collectionView, true)
        }
    }
    
    private func isEmptyViewNeededFor(_ collectionView: UICollectionView,_ needed: Bool ) {
        DispatchQueue.main.async {
            if collectionView == self.personalCollectionView {
                self.personalEmptyView.isHidden = !needed
            }
            else if collectionView == self.professionalCollectionView {
                self.professionalEmptyView.isHidden = !needed
            }
        }
    }
    
    func presentRetyAlert(message: String? = "", title: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default) { alertAction in
                self.isTabBarEnable(false)
                self.reloadSettings()
            }
            alertController.addAction(retryAction)
            self.navigationController?.present(alertController, animated: true, completion: nil)
    }
}
