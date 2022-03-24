//
//  UpdateProjectVC+UITextViewDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 28/12/2021.
//

import Foundation
import UIKit

extension UpdateProjectViewController: UITextViewDelegate {
    
    //Remove placeholder set textColor to label
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    //Add commentary placeHolder and set textColor to placeholder 
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.Label.commentaryPlaceHolder
            textView.textColor = .placeholderText
        }
    }
}
