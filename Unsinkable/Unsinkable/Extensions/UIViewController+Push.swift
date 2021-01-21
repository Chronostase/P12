//
//  UIViewController+Push.swift
//  Unsinkable
//
//  Created by Thomas on 13/01/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
}
