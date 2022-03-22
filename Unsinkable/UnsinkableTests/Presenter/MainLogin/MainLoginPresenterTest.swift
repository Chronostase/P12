//
//  MainLoginPresenterTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 02/03/2022.
//
@testable import Unsinkable
import XCTest
import Foundation

class MainLoginPresenterTest: XCTestCase {
    lazy var mainLoginPresenter = {
        return MainLoginPresenter()
    }()
    
    func testNavStackNeedManageShouldReturnTrueIfCorrectCount() {
        XCTAssertTrue(mainLoginPresenter.navStackNeedManage(2))
    }
    
    func testNavStackNeedManageShoulReturnFalseIfIncorrectCount() {
        XCTAssertFalse(mainLoginPresenter.navStackNeedManage(1))
    }
}

