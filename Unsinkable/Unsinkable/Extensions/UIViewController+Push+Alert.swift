//
//  UIViewController+Push+Alert.swift
//  Unsinkable
//
//  Created by Thomas on 13/01/2021.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK: - Navigation
    //Push VC
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    //Present Loader
    func showLoader() {
        let loadingVC = LoaderViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        navigationController?.present(loadingVC, animated: true, completion: nil)
    }
    
    //present Simpler alertController
    func presentSimpleAlert(message: String? = "", title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.navigationController?.present(alertController, animated: true, completion: nil)
      }
    
    //Present AlertController that popVC 
    func alertThatNeedPop(message: String = "", title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
}
