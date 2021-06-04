//
//  Coordinator.swift
//  Unsinkable
//
//  Created by Thomas on 26/01/2021.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}
