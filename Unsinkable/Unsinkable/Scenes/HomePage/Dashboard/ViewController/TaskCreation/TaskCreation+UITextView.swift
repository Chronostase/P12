//
//  TaskCreation+UITextView.swift
//  Unsinkable
//
//  Created by Thomas on 13/10/2021.
//

import Foundation
import UIKit

extension TaskCreationViewController: UITextViewDelegate {
    
    //Remove textView placeHolder and set textColor to label
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    //Add textView placeHolder and set textColor to placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.Label.commentaryPlaceHolder
            textView.textColor = .placeholderText
        }
    }
}
