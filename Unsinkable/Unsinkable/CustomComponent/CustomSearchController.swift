//
//  CustomSearchController.swift
//  Unsinkable
//
//  Created by Thomas on 01/02/2022.
//

import Foundation
import UIKit

class CustomSearchController: UISearchController {
    
    public var customSearchBar = UISearchBar()
        override public var searchBar: UISearchBar {
            get {
                return customSearchBar
            }
        }
}
