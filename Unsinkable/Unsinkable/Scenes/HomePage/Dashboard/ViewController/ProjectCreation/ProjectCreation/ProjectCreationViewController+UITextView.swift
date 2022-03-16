//
//  ProjectCreationViewController+UITextView.swift
//  Unsinkable
//
//  Created by Thomas on 15/03/2022.
//

import Foundation
import UIKit

extension ProjectCreationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.Label.descriptionPlaceHolder
            textView.textColor = .placeholderText
        }
    }
}
