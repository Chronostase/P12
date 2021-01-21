//
//  StringExtension.swift
//  Unsinkable
//
//  Created by Thomas on 21/01/2021.
//

import Foundation

extension String {
    
    func formatCharacter() -> String {
        let newString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return newString
    }
}
