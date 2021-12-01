//
//  Keys.swift
//  Unsinkable
//
//  Created by Thomas on 23/11/2021.
//

import Foundation

class Keys {
    
    static func value(for key: String) -> String? {
        guard let keysPlist = Bundle.main.path(forResource: "Keys",ofType: "plist"),
            let keys = NSDictionary(contentsOfFile: keysPlist),
            let key = keys[key] as? String else {
                return nil
        }
        
        return key
    }
}
