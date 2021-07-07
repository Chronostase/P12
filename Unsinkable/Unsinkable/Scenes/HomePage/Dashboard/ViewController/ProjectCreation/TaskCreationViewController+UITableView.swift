//
//  TaskCreationViewController+UITableView.swift
//  Unsinkable
//
//  Created by Thomas on 02/07/2021.
//

import Foundation
import UIKit

extension TaskCreationViewController: UITableViewDelegate {
    
}

extension TaskCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
}
