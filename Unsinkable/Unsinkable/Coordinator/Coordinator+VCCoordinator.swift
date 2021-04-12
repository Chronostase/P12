//
//  Coordinator.swift
//  Unsinkable
//
//  Created by Thomas on 26/01/2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinator: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
    
    func register()
    
    func signIn()
}

protocol VCCoordinator {
    var coordinator: CoordinatorManager? {get set}
}
