//
//  NotificationCoordinator.swift
//  Unsinkable
//
//  Created by Thomas on 25/05/2021.
//

import Foundation
import UIKit

class NotificationCoordinator: Coordinator {
    var childCoordinator = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("")
    }
    
    
}
