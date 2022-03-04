//
//  LoginPresenterTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 24/02/2022.
//
@testable import Unsinkable
import Foundation
import XCTest

class LoginPresenterTest: XCTestCase {
    
    lazy var loginPresenter = {
        return LoginPresenter(session: LoginServiceFake())
    }()
    
    var fakeStorage: FakeStorage!
    
    
//    var loginService: LoginServiceFake {
//        return LoginServiceFake()
//    }
    override class func setUp() {
        super.setUp()
        UserAuthenticationServiceTest.fakeStorage = []
    }
    override class func tearDown() {
        super.tearDown()
        UserAuthenticationServiceTest.fakeStorage = []
    }
    
    func testEmailShouldFailIfIsNil() {
        XCTAssertFalse(loginPresenter.isEmailValid(nil))
    }
    
    func testIsEmailValidShouldWorkIfCorrectEmail() {
        XCTAssertTrue(loginPresenter.isEmailValid("thomas.giron@gmail.fr"))
    }
    
    func testIsEmailValidShouldFailedIfIncorrectEmail() {
        XCTAssertFalse(loginPresenter.isEmailValid("XXXX"))
    }
    
    func testIsFieldsAvailableShouldFailIfNil() {
        XCTAssertFalse(loginPresenter.isTextFieldAvailable(nil, nil))
    }
    func testIsFieldsAvailableShouldWorkIfCorrectFields() {
        XCTAssertTrue(loginPresenter.isTextFieldAvailable("Something@outlook.fr", "XXXXXXX"))
    }

    func testIsFieldsAvailableShoulNotdWorkIfIncorrectFields() {
        XCTAssertFalse(loginPresenter.isTextFieldAvailable("Something@outlook.fr", ""))
    }

    func testIsFieldsAvailableShoulNocorrectFields() {
        XCTAssertFalse(loginPresenter.isTextFieldAvailable("", ""))
    }
    
    func testLoginUserShouldWorkIfCorrectCredential() {
        loginPresenter.logUser("test@gmail.fr", "12345678") { result in
            switch result {
            case .success(let customResponse):
                XCTAssertNotNil(customResponse)
            case .failure(let error):
                XCTAssertNil(error)
                
            }
        }
    }
    
    func testLoginUserShouldFailedIfIncorrectCredential() {
        loginPresenter.logUser("Uncorrect@gmail.fr", "1ZRCZFE") { result in
            switch result {
            case .success(let customResponse):
                XCTAssertNil(customResponse)
            case .failure(let error):
                XCTAssertNotNil(error)
                
            }
        }
    }
    
    func testLoginUserShouldFailedIfInvalidFields() {
        //Need to see if i can assert delegate
        loginPresenter.logUser("", "") { result in
            switch result {
            case .success(let customResponse):
                XCTAssertNil(customResponse)
            case .failure(let error):
                XCTAssertNotNil(error)
                
            }
        }
    }
    
    
    //See to replace by Delegate assert
    func testLoginUserShouldFailedIfInvalidEmail() {
        //see to assert Delegate
        loginPresenter.logUser("somethingincorrect", "efzegf") { result in
            switch result {
            case .success(let customResponse):
                XCTAssertNil(customResponse)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testLoginShouldWorkIfCorrectCredential() {
        loginPresenter.login("test@gmail.fr", "12345678")
    
    }
    
    func testLoginShouldFailedIfInorrectCredential() {
        loginPresenter.login("testingthing@gmail.com", "345678")
    
    }



}
