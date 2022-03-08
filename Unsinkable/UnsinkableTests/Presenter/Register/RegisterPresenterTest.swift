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

    var registerPresenter: RegisterPresenter?
    var registerService: RegisterServiceFake?
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
        registerService = RegisterServiceFake()
        registerPresenter = RegisterPresenter(session: registerService!)
        registerPresenter?.registerDelegate = self 
    }
    private func resetData() {
        isCorrect = nil
        registerPresenter = nil
        registerService = nil
        
    }
    
    func testIsEmailValidShouldWorkIfCorrectEmail() {
        guard let value = registerPresenter?.isEmailValid("thomas.giron@gmail.fr") else {return}
        XCTAssertTrue(value)
    }
    
    func testIsEmailValidShouldFailedIfIncorrectEmail() {
        guard let value = registerPresenter?.isEmailValid("XXXXX") else {return}
        XCTAssertFalse(value)
    }
    
    func testIsEmailValidShouldFailedIfEmailIsNil() {
        guard let value = registerPresenter?.isEmailValid(nil) else {return}
        XCTAssertFalse(value)
    }
    
    func testFormatFieldShouldWorkIfCorrectString() {
        guard let value = registerPresenter?.formatFields(string: "Something") else {return}
            XCTAssertNotNil(value)
    }
    
    func testFormatFieldShouldFailedIfStringIsNil() {
        guard let value = registerPresenter?.formatFields(string: nil) else {return}
        XCTAssertNil(value)
    }
    
    func testIsPasswordValidShouldWorkIfCorrectPassword() {
        guard let value = registerPresenter?.isPasswordValid(password: "aZerty12!") else {return}
        XCTAssertTrue(value)
    }
    
    func testIsPasswordValidShoulFailIfIncorrectPassword() {
        guard let value = registerPresenter?.isPasswordValid(password: "www!") else {return}
        XCTAssertFalse(value)
    }
    
    func testIsPasswordValidShoulFailIfPasswordIsNil() {
        guard let value = registerPresenter?.isPasswordValid(password: nil) else {return}
        XCTAssertFalse(value)
    }
    
    func testIsInformerdFieldShouldWorkIfCorrectString() {
        guard let value = registerPresenter?.isInformedField("Something") else {return}
        XCTAssertTrue(value)
    }
    
    func testIsInformedFieldShouldFailIfIncorrectString() {
        guard let value = registerPresenter?.isInformedField("a") else {return}
        XCTAssertFalse(value)
    }
    
    func testIsInformedFieldShouldFailIfStringIsNil() {
        guard let value = registerPresenter?.isInformedField(nil) else {return}
        XCTAssertFalse(value)
    }
    
    func testIsAllFieldsValidShouldWorkIfAllCorrectFields() {
        guard let value = registerPresenter?.isAllFieldsValid("thomas", "giron", "thomas.giron@gmail.com", "aZerty12!") else {return}
        XCTAssertTrue(value)
    }
    
    func testIsAllFieldsValidShouldFailIfFieldIsMissing() {
        guard let value = registerPresenter?.isAllFieldsValid(nil, "giron", "thomas.giron@gmail.com", "aZerty12!") else {return}
        XCTAssertFalse(value)
    }
    
    func testIsAllFieldsValidShouldFailIfIncorrectEmail() {
        guard let value = registerPresenter?.isAllFieldsValid("thomas", "giron", "thomas.girongmail.com", "aZerty12!") else {return}
        XCTAssertFalse(value)
    }
    
    func testIsAllFieldsValidShouldFailIfIncorrectPassword() {
        guard let value = registerPresenter?.isAllFieldsValid("thomas", "giron", "thomas.giron@gmail.com", "aZe!") else {return}
        XCTAssertFalse(value)
    }
    
    func testRegisterUserShouldWorkIfCorrectFields() {
        //Should work
        registerService?.database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "non@gmail.com", password: "azert", firstName: "Jean", name: "Duj", userId: "AEIO", projects: nil)))
        registerPresenter?.registerUser("thomas", "giron", "thomas.giron@gmail.com", "azertY12!") { result in
            switch result {
            case .success(let void):
                XCTAssertNotNil(void)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testRegisterUserShouldFailIfEmailAlreadyUsed() {
        registerService?.database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "thomas.giron@gmail.fr", password: "azert", firstName: "Jean", name: "Duj", userId: "AEIO", projects: nil)))
        
        registerPresenter?.registerUser("thomas", "giron", "thomas.giron@gmail.fr", "AzertyuiU12!") { result in
            switch result {
            case .success(let void):
                XCTAssertNil(void)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testRegisterWithShouldWorkIfCorrectUser() {
        registerService?.database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "thomas.giron@gmail.fr", password: "azert", firstName: "Jean", name: "Duj", userId: "AEIO", projects: nil)))
        
        registerPresenter?.registerWith("thomas", "giron", "thomas.giron@gmail.com", "azertY12!")
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testRegisterWithShouldFailedIfIncorrectUser() {
        registerService?.database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "thomas.giron@gmail.fr", password: "azert", firstName: "Jean", name: "Duj", userId: "AEIO", projects: nil)))
        
        registerPresenter?.registerWith("thomas", "Duj", "thomas.giron@gmail.fr", "azertyUIO12!")
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
}

extension RegisterPresenterTest: RegisterPresenterDelegate {
    func registerComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            isCorrect = true
        case . failure(_):
            isCorrect = false
        }
    }
    
    func empltyFields() {
        isCorrect = false
    }
    
    func invalidPassword() {
        isCorrect = false
    }
    
    func invalidEmail() {
        isCorrect = false
    }
    
    
}
