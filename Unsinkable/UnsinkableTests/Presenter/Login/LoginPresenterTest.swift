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
    
    var loginPresenter: LoginPresenter?
    var loginService: LoginServiceFake?
    var isCorrect: Bool?
    
    override func setUp() {
        super.setUp()
        initData()
    }
    override func tearDown() {
        super.tearDown()
        resetData()
    }
    
    private func initData() {
        isCorrect = Bool()
        loginService = LoginServiceFake()
        loginPresenter = LoginPresenter(session: loginService!)
        loginPresenter?.delegate = self
    }
    private func resetData() {
        isCorrect = nil
        loginPresenter = nil
        loginService = nil
        
    }
    
    func testEmailShouldFailIfIsNil() {
        guard let value = loginPresenter?.isEmailValid(nil) else {return}
        XCTAssertFalse(value)
    }
    
    func testIsEmailValidShouldWorkIfCorrectEmail() {
        guard let value = loginPresenter?.isEmailValid("thomas.giron@gmail.fr") else {return}
        XCTAssertTrue(value)
    }
    
    func testIsEmailValidShouldFailedIfIncorrectEmail() {
        guard let value = loginPresenter?.isEmailValid("XXXX") else {return}
        XCTAssertFalse(value)
    }
    
    func testIsFieldsAvailableShouldFailIfNil() {
        guard let value = loginPresenter?.isTextFieldAvailable(nil, nil) else {return}
        XCTAssertFalse(value)
    }
    func testIsFieldsAvailableShouldWorkIfCorrectFields() {
        guard let value = loginPresenter?.isTextFieldAvailable("Something@outlook.fr", "XXXXXX") else {return}
        XCTAssertTrue(value)
    }

    func testIsFieldsAvailableShoulNotdWorkIfIncorrectFields() {
        guard let value = loginPresenter?.isTextFieldAvailable("Something@outlook.fr", "") else {return}
        XCTAssertFalse(value)
    }

    func testIsFieldsAvailableShoulNocorrectFields() {
            guard let value = loginPresenter?.isTextFieldAvailable("", "") else {return}
        XCTAssertFalse(value)
    }
    
    func testLoginUserShouldWorkIfCorrectCredential() {
        loginPresenter?.logUser("test@gmail.fr", "12345678") { result in
            switch result {
            case .success(let customResponse):
                XCTAssertNotNil(customResponse)
            case .failure(let error):
                XCTAssertNil(error)
                
            }
        }
    }
    
    func testLoginUserShouldFailedIfIncorrectCredential() {
        loginPresenter?.logUser("Uncorrect@gmail.fr", "1ZRCZFE") { result in
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
        loginPresenter?.logUser("", "") { result in
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
        loginPresenter?.logUser("somethingincorrect", "efzegf") { result in
            switch result {
            case .success(let customResponse):
                XCTAssertNil(customResponse)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testLoginShouldWorkIfCorrectCredential() {
        loginPresenter?.login("test@gmail.fr", "12345678")
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
        

    }

    func testLoginShouldFailedIfInorrectCredential() {
        loginPresenter?.login("testingthing@gmail.com", "345678")
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)

    }
}

extension LoginPresenterTest: LoginPresenterDelegate {
    
    func loginSucceed() {
        isCorrect = true
    }
    
    func loginFailed(_ message: String?) {
        isCorrect = false
    }
    
    func emptyFields() {
        isCorrect = false
    }
}
