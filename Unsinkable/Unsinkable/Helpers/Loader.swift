//
//  Loader.swift
//  Unsinkable
//
//  Created by Thomas on 07/07/2021.
//

import Foundation
import UIKit

class LoaderViewController: UIViewController {
    
    var loadingActivityIndicator: UIActivityIndicatorView = {
        // UIActivityIndicatorView Configuration
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        
        indicator.startAnimating()
        
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        
        return indicator
    }()
    
    var blurEffectView: UIVisualEffectView = {
        // UIVisualEffectView Configuration
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        
        // Setting the autoresizing mask to flexible for
        // width and height will ensure the blurEffectView
        // is the same size as its parent view.
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        // View Configuration
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            // Add the blurEffectView with the same
            // size as view
            blurEffectView.frame = self.view.bounds
            view.insertSubview(blurEffectView, at: 0)
            
            // Add the loadingActivityIndicator in the
            // center of view
            loadingActivityIndicator.center = CGPoint(
                x: view.bounds.midX,
                y: view.bounds.midY
            )
            view.addSubview(loadingActivityIndicator)
    }
}
