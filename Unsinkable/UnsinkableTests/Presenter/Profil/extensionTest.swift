//
//  extensionTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 22/03/2022.
//
@testable import Unsinkable
import Foundation
import XCTest

class ExtensionTest: XCTestCase {
    
    
    func testFormatCharacterShouldReturnStringWithoutWhispace() {
        let newString = "     Something without     ".formatCharacter()
        XCTAssertEqual(newString, "Something without")
    }
}
