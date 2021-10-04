//
//  ProjectReaderVC+TableViewDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 30/09/2021.
//

import Foundation
import UIKit

extension ProjectReaderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell() 
    }
    
    
}

extension ProjectReaderViewController: UITableViewDelegate {
    
}
