//
//  UIViewController+Push+KBAnimation.swift
//  Unsinkable
//
//  Created by Thomas on 13/01/2021.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK: - Navigation Part
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    //MARK: - Keyboard Part
    
    
    func startAvoidingKeyboard() {
        //KB will show
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        //KB will hide
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func stopAvoidingKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               // if keyboard size is not available for some reason, dont do anything
               return
            }
        if let vc = self as? ProjectCreationViewController {
            if isHideByKeyboard(vc.activatedObject, keyboardSize) {
                //Block UIAnimated
                UIView.animate(withDuration: 0.2) {
                    self.view.frame.origin.y = 0 - keyboardSize.height
                }
            }
        }
    }
    
    private func isHideByKeyboard(_ nsObject: NSObject?, _ keyboardSize: CGRect) -> Bool {
        if let activatedObject = nsObject {
            if let object = activatedObject as? UITextField {
                let objectBottomY = object.convert(object.bounds, to: self.view).maxY
                let topOfKeyboard = self.view.frame.height - keyboardSize.height

                    // if the bottom of Textfield is below the top of keyboard, move up
                    if objectBottomY > topOfKeyboard {
                      return  true
                    }
            } else if let object = activatedObject as? UITextView {
                let objectBottomY = object.convert(object.bounds, to: self.view).maxY
                let topOfKeyboard = self.view.frame.height - keyboardSize.height

                    // if the bottom of Textfield is below the top of keyboard, move up
                    if objectBottomY > topOfKeyboard {
                      return true
                    }
            } else {
                return false
            }
            
        }
        return false
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
