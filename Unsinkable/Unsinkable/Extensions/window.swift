//
//  window.swift
//  Unsinkable
//
//  Created by Thomas on 21/05/2021.
//

import UIKit

/** Extension of `UIApplication` to get a given key window */
extension UIApplication {
    
    /** Get the current key window. */
    var currentKeyWindow: UIWindow? {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
    }
}
