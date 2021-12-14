//
//  MainLoginPresenter.swift
//  Unsinkable
//
//  Created by Thomas on 30/11/2021.
//

import Foundation
import Security

class MainLoginPresenter {
    
    func navStackNeedManage(_ navStackCount: Int) -> Bool {
        if navStackCount > 1 {
            return true
        } else {
            return false
        }
    }
}
