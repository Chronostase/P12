//
//  ProjectCreationViewController+UITextView.swift
//  Unsinkable
//
//  Created by Thomas on 15/03/2022.
//

import Foundation
import UIKit

extension ProjectCreationViewController: UITextViewDelegate {
    
    //Remove placeHolder and set textColor to label
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    //Add placeHolder and set placeHolder text color
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.Label.descriptionPlaceHolder
            textView.textColor = .placeholderText
        }
    }
}
