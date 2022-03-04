//
//  RegisterPresenterTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 02/03/2022.
//
@testable import Unsinkable
import XCTest
import Foundation

class RegisterPresenterTest: XCTestCase {
    var fakeUser: FakeUserDetails!
    
    lazy var registerPresenter = {
        return RegisterPresenter(session: RegisterServiceFake())
    }()
    
    override class func setUp() {
        super.setUp()
        UserAuthenticationServiceTest.fakeStorage = []
    }
    
    override class func tearDown() {
        super.tearDown()
        UserAuthenticationServiceTest.fakeStorage = []
    }
    
    func testIsEmailValidShouldWorkIfCorrectEmail() {
        XCTAssertTrue(registerPresenter.isEmailValid("thomas.giron@gmail.fr"))
    }
    
    func testIsEmailValidShouldFailedIfIncorrectEmail() {
        XCTAssertFalse(registerPresenter.isEmailValid("XXXXX"))
    }
    
    func testIsEmailValidShouldFailedIfEmailIsNil() {
        XCTAssertFalse(registerPresenter.isEmailValid(nil))
    }
    
    func testFormatFieldShouldWorkIfCorrectString() {
            XCTAssertNotNil(registerPresenter.formatFields(string:"Something"))
    }
    
    func testFormatFieldShouldFailedIfStringIsNil() {
        XCTAssertNil(registerPresenter.formatFields(string: nil))
    }
    
    func testIsPasswordValidShouldWorkIfCorrectPassword() {
        XCTAssertTrue(registerPresenter.isPasswordValid(password: "aZerty12!"))
    }
    
    func testIsPasswordValidShoulFailIfIncorrectPassword() {
        XCTAssertFalse(registerPresenter.isPasswordValid(password: "www"))
    }
    
    func testIsPasswordValidShoulFailIfPasswordIsNil() {
        XCTAssertFalse(registerPresenter.isPasswordValid(password: nil))
    }
    
    func testIsInformerdFieldShouldWorkIfCorrectString() {
        XCTAssertTrue(registerPresenter.isInformedField("Something"))
    }
    
    func testIsInformedFieldShouldFailIfIncorrectString() {
        XCTAssertFalse(registerPresenter.isInformedField("a"))
    }
    
    func testIsInformedFieldShouldFailIfStringIsNil() {
        XCTAssertFalse(registerPresenter.isInformedField(nil))
    }
    
    func testIsAllFieldsValidShouldWorkIfAllCorrectFields() {
        XCTAssertTrue(registerPresenter.isAllFieldsValid("thomas", "giron", "thomas.giron@gmail.com", "aZerty12!"))
    }
    
    func testIsAllFieldsValidShouldFailIfFieldIsMissing() {
        XCTAssertFalse(registerPresenter.isAllFieldsValid(nil, "giron", "thomas.giron@gmail.com", "aZerty12!"))
    }
    
    func testIsAllFieldsValidShouldFailIfIncorrectEmail() {
        XCTAssertFalse(registerPresenter.isAllFieldsValid("thomas", "giron", "thomas.girongmail.com", "aZerty12!"))
    }
    
    func testIsAllFieldsValidShouldFailIfIncorrectPassword() {
        XCTAssertFalse(registerPresenter.isAllFieldsValid("thomas", "giron", "thomas.giron@gmail.com", "aZe!"))
    }
    
    func testRegisterUserShouldWorkIfCorrectFields() {
        registerPresenter.registerUser("thomas", "giron", "thomas.giron@gmail.com", "azertY12!")
    }
    
    func testRegisterUserShouldFailIfIncorrectFields() {
        registerPresenter.registerUser(nil, nil, nil, nil)
    }
    
    func testRegisterUserShouldFailIfEmailAlreadyUsed() {
        registerPresenter.registerUser("thomas", "giron", "thomas.giron@gmail.fr", "AzertyuiU12!")
    }
    
}
