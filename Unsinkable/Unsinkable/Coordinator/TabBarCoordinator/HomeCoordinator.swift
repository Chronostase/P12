//
//  HomeCoordinator.swift
//  Unsinkable
//
//  Created by Thomas on 19/05/2021.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    
    
    weak var parentCoordinator: CoordinatorManager?
    var childCoordinator = [Coordinator]()
    var data = CustomResponse(user: UserDetails())
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        tabBar()
    }
    
    func tabBar() {
        let tabBarViewController = TabBarViewController()
        tabBarViewController.homeCoordinator = self
        tabBarViewController.setViewControllers(self.setupVC(), animated: true)
        navigationController.pushViewController(tabBarViewController, animated: true)
    }
    
    private func setupVC() -> [UIViewController]? {
        let storyboard = UIStoryboard(name: Constants.StoryBoard.dashBoard, bundle: Bundle.main)
        guard let dashBoardViewController = storyboard.instantiateInitialViewController() as? DashBoardViewController else {
            return nil
        }
        dashBoardViewController.coordinator = self
        let secondStoryboard = UIStoryboard(name: Constants.StoryBoard.notificationCenter, bundle: Bundle.main)
        guard let notificationViewController = secondStoryboard.instantiateInitialViewController() as? NotificationCenterViewController else {
            return nil
        }
        let dashBoardNavigationViewController = UINavigationController(rootViewController: dashBoardViewController)
        dashBoardViewController.tabBarItem.image = UIImage(named: Constants.Image.clipBoard )
        let notificationNavigationController = UINavigationController(rootViewController: notificationViewController)
        notificationViewController.tabBarItem.image = UIImage(systemName: Constants.Image.bell)
        
        return [dashBoardNavigationViewController, notificationNavigationController]
    }
    
    func profil(_ data: CustomResponse?) {
        let storyBoard = UIStoryboard(name: Constants.StoryBoard.profil, bundle: Bundle.main)
        guard let profilViewController = storyBoard.instantiateInitialViewController() as? ProfilViewController else {
            return
        }
        profilViewController.profilPresenter.data = data
        profilViewController.coordinator = self
        navigationController.pushViewController(profilViewController, animated: true)
        
    }
    
    func projectCreation(isPersonal: Bool, _ data: CustomResponse?, localTasksList: [Task?]? = []) {
        let storyboard = UIStoryboard(name: Constants.StoryBoard.projectCreation, bundle: Bundle.main)
        guard let projectVC = storyboard.instantiateInitialViewController() as? ProjectCreationViewController else {
            return
        }
        projectVC.coordinator = self
        projectVC.projectCreationPresenter.localTasksList = localTasksList
        projectVC.projectCreationPresenter.data = data
        projectVC.projectCreationPresenter.isPersonal = isPersonal
        navigationController.pushViewController(projectVC, animated: true)
    }
    
    func projectReader(project: Project,_ userData: CustomResponse) {
        let storyboard = UIStoryboard(name: Constants.StoryBoard.projectReading, bundle: Bundle.main)
        guard let projectReaderVC = storyboard.instantiateInitialViewController() as? ProjectReaderViewController else {
            return
        }
        projectReaderVC.projectReaderPresenter.selectedProject = project
        projectReaderVC.projectReaderPresenter.userData = userData
        projectReaderVC.coordinator = self
        navigationController.pushViewController(projectReaderVC, animated: true)
    }
    
    func taskEditor(task: Task, _ project: Project? = nil, parentCreationVC: ProjectManagerDelegate? = nil, _ isReader: Bool = false,_ userData: CustomResponse? = nil) {
        let storyboard = UIStoryboard(name: Constants.StoryBoard.taskEditor, bundle: Bundle.main)
        guard let taskEditorVC = storyboard.instantiateInitialViewController() as? TaskCreationViewController else {
            return
        }
        taskEditorVC.coordinator = self
        taskEditorVC.taskCreationPresenter.isReader = isReader
        taskEditorVC.taskCreationPresenter.delegate = parentCreationVC
        taskEditorVC.taskCreationPresenter.task = task
        taskEditorVC.taskCreationPresenter.project = project
        taskEditorVC.taskCreationPresenter.userData = userData
        navigationController.pushViewController(taskEditorVC, animated: true)
    }
    
    func updateProject(_ project: Project?, _ userData: CustomResponse?) {
        let storyboard = UIStoryboard(name: Constants.StoryBoard.updateProject, bundle: Bundle.main)
        guard let updateProjectVC = storyboard.instantiateInitialViewController() as? UpdateProjectViewController else {return}
        
        updateProjectVC.coordinator = self
        updateProjectVC.updateProjectPresenter.currentProject = project
        updateProjectVC.updateProjectPresenter.userData = userData
        updateProjectVC.modalTransitionStyle = .crossDissolve
        updateProjectVC.modalPresentationStyle = .overFullScreen
        navigationController.present(updateProjectVC, animated: true, completion: nil)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
}

