//
//  UserAuthenticationServiceTest.swift
//  UnsinkableTests
//
//  Created by Thomas on 22/04/2021.
//
@testable import Unsinkable
import FirebaseAuth
import XCTest



class UserAuthenticationServiceTest: XCTestCase {
    var fakeUser: UserDetails!
    var fakeStorage = [CustomResponse]()
    var authenticationService: UserAuthentificationService {
        return UserAuthentificationService(session: AuthenticationSessionFake(fakeUser: fakeUser, fakeStorage: fakeStorage))
    }
    
    // MARK: - Test Login
    
    func testLoginShouldSucceedIfCorrectUserEmailAndPassword() {
        // Given
        fakeUser = UserDetails(email: "jean@email.fr", password: "1234")
        
        //When
        authenticationService.loginUser("jean@email.fr", "1234") { (result) in
            
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testLoginShouldFailedIfCorrectEmailButBadPassword() {
        //Given
        fakeUser = UserDetails(email: "jean@email.fr", password: "1234")
        
        //When
        authenticationService.loginUser("jean@email.fr", "134") { (result) in
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testLoginShouldFailedIfBadEmailButCorrectPassword() {
        //Given
        fakeUser = UserDetails(email: "jean@email.fr", password: "1234")
        //When
        authenticationService.loginUser("jean@mail.fr", "1234") { (result) in
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    // MARK: - Test Register
    
    func testRegisterShouldFailedIfUserAlreadyExist() {
        fakeUser = UserDetails(email: "jean@email.fr", password: "1234", userId: "3x12fbdg")
        authenticationService.createUserWithInformations("Jean", "Dujardin", "jean@email.fr", "1234") { (result) in
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testRegisterShouldSucceedIfCorrectAndNewUser() {
        fakeUser = UserDetails(email: "jean@email.fr", password: "1234", userId: "3x12fbdg")
        authenticationService.createUserWithInformations("Jean", "Dujardin", "jea@email.fr", "1234") { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testShouldWorkIfCreateUserSuccessAndStoredUserSuccess() {
        fakeUser = UserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        fakeStorage.append(CustomResponse(user: UserDetails(email: "jpp@outlook.fr", password: "12345", displayName: "trufle", userId: "ARGJB1857NFJ")))
        authenticationService.createUserWithInformations("Victor", "Giron", "vg@outook.fr", "1234") { (result) in
            switch result {
            case .success(let response):
                guard let customResult = response else { return }
                self.authenticationService.storeUser(customResult, firstName: "Victor", "Giron", email: "vg@outlook.fr", password: "1234") { (something, error) in
                    if error != nil {
                        XCTAssertNotNil(error)
                    } else {
                        XCTAssertNotNil(something)
                    }
                }
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testShouldNotWorkIfCreateUserFailed() {
        fakeUser = UserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        let customResponse = CustomResponse(user: fakeUser)
        fakeStorage.append(customResponse)
        authenticationService.createUserWithInformations("Victor", "Giron", "vg@outook.fr", "1234") { (result) in
            switch result {
            case .success(_):
//                self.fakeStorage.append(customResponse)
                self.authenticationService.storeUser(customResponse, firstName: "Victor", "Giron", email: "vg@outlook.fr", password: "1234") { (something, error) in
                    if error != nil {
                        XCTAssertNotNil(error)
                    } else {
                        XCTAssertNotNil(something)
                    }
                }
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    //MARK: - Test Storage
    
    func testStorageShouldWorkIfCorrectAndNewUser() {
        fakeUser = UserDetails(email: "jean@email.fr", password: "1234", userId: "3x12fbdg")
        let fiellField = CustomResponse(user: UserDetails(email: "jeanqrsgeqr@email.fr", password: "1234", userId: "3x12fr(hsebdg"))
        fakeStorage.append(fiellField)
        let customeResponse = CustomResponse(user: UserDetails(email: "jean@email.fr", password: "1234", userId: "3x12fbdg"))
        authenticationService.storeUser(customeResponse, firstName: "Jean", "Duj", email: "jean@email.fr", password: "1234") { (response, error) in
            //Rentre pas dans les assert
            if error == nil {
                XCTAssertNotNil(response)
            }
            XCTAssertNil(error)
        }
    }
    
    
    func testStorageShouldFailedIfCorrectAndNotNewUser() {
        fakeUser = UserDetails(email: "jean@email.fr", password: "1234", userId: "3x12fbdg")
        let customeResponse = CustomResponse(user: UserDetails(email: "jean@email.fr", password: "1234", userId: "3x12fbdg"))
        fakeStorage.append(customeResponse)
        authenticationService.storeUser(customeResponse, firstName: "Jean", "Duj", email: "jean@email.fr", password: "1234") { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }

}

