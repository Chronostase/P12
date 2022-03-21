//
//  ProfilPresenterTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 21/03/2022.
//
@testable import Unsinkable
import XCTest
import Foundation

class ProfilPresenterTest: XCTestCase {
    
    var profilPresenter: ProfilPresenter? 
    var projectService: ProjectProfilServiceFake?
    var authService: AuthProfilServiceFake?
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
        projectService = ProjectProfilServiceFake()
        authService = AuthProfilServiceFake()
        profilPresenter = ProfilPresenter(authSession: authService!, projectSession: projectService!)
        profilPresenter?.data = CustomResponse(user: UserDetails(email: "thomas@gmail.com", firstName: "thomas", name: "Giron", userId: "AZERTY", projects: []))
        projectService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: [])
        authService?.fakeUser = FakeUserDetails(email: "", password: "", firstName: "", name: "", userId: "AZERTY", projects: [])
        profilPresenter?.delegate = self
    }
    
    private func resetData() {
        projectService = nil
        authService = nil
        profilPresenter = nil
        isCorrect = nil
    }
    
    func testIsEmailValidShouldReturnFalseIfEmailIsNil() {
        guard let value = profilPresenter?.isEmailValid(nil) else {return}
        XCTAssertFalse(value)
    }
    
    func testIsEmailValidShouldReturnFalseIfIncorrectEmail() {
        guard let value = profilPresenter?.isEmailValid("somethingthat'snotaemail") else {return}
        XCTAssertFalse(value)
    }
    
    func testIsEmailValidShouldReturnTrueIfCorrectEmail() {
        guard let value = profilPresenter?.isEmailValid("thomas@gmail.com") else {return}
        XCTAssertTrue(value)
    }
    
    func testDeleteAllUserRefShouldReturnTrueIfCorrectUser() {
        profilPresenter?.deleteAllUserRef()
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testDeleteAllUserRefShoulReturnFalseIfIncorrectUser() {
        profilPresenter?.data?.user.userId = "XXXXXX"
        profilPresenter?.deleteAllUserRef()
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testLogOutShouldReturnFalseIfNoUser() {
        authService?.fakeUser = nil
        profilPresenter?.logOut()
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testLogOutShouldReturnTrueIfCorrectUSerId() {
        profilPresenter?.logOut()
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testDeleteUserShouldWorkIfCorrectUserId() {
        profilPresenter?.deleteUser()
        guard let value = isCorrect else {return}
        XCTAssertTrue(value)
    }
    
    func testDeleteUserShouldFailIfIncorrectUserId() {
        authService?.fakeUser?.userId = "XXX"
        profilPresenter?.deleteUser()
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }
    
    func testUpdateUserShouldFailIfEmptyString() {
        profilPresenter?.updateUser("", "", "")
        guard let value = isCorrect else {return}
        XCTAssertFalse(value)
    }

}

extension ProfilPresenterTest: ProfilPresenterDelegate {
    func logoutComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    func deleteUserComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    func updateUserComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
    
    func showError(_ message: String) {
        isCorrect = false
    }
    
    func deleteAllUSerRefComplete(_ result: Result<Void, UnsinkableError>) {
        switch result {
        case .success(()):
            isCorrect = true
        case .failure(_):
            isCorrect = false
        }
    }
}
