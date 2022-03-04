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
    
    //Move to setup / reset tears down
    var fakeUser: FakeUserDetails!
    static var fakeStorage: [FakeCustomResponse] = []
    var authenticationService: UserAuthenticationService {
        return UserAuthenticationService(session: AuthenticationSessionFake(fakeUser: fakeUser))
    }
    
    override func setUp() {
        super.setUp()
        resetStorage()
    }
    override func tearDown() {
        super.tearDown()
        resetStorage()
    }
    
    func resetStorage() {
        UserAuthenticationServiceTest.fakeStorage = []
    }
    
    
    // MARK: - Test Login
    
    func testLoginShouldSucceedIfCorrectUserEmailAndPassword() {
        // Given
        fakeUser = FakeUserDetails(email: "jean@email.fr", password: "1234")

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
        fakeUser = FakeUserDetails(email: "jean@email.fr", password: "1234")

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
        fakeUser = FakeUserDetails(email: "jean@email.fr", password: "1234")
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

//    // MARK: - Test Register

    func testRegisterShouldFailedIfUserAlreadyExist() {
        fakeUser = FakeUserDetails(email: "jean@email.fr", password: "1234", userId: "3x12fbdg")
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
        fakeUser = FakeUserDetails(email: "jean@email.fr", password: "1234", userId: "3x12fbdg")
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
        fakeUser = FakeUserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "jpp@outlook.fr", password: "12345", userId: "ARGJB1857NFJ")))
        authenticationService.createUserWithInformations("Victor", "Giron", "vg@outook.fr", "1234") { (result) in
            switch result {
            case .success(_):
                let customResult = CustomResponse(user: UserDetails(email: "vg@outook.fr", firstName: "Victor", name: "Giron", userId: "3XDFR45GT", projects: nil))

                self.authenticationService.storeUser(customResult, firstName: "Victor", "Giron") { (storeResult) in
                    switch storeResult {
                    case .success(let void):
                        XCTAssertNotNil(void)
                    case .failure(let error):
                        XCTAssertNil(error)
                    }
                }
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

    func testShouldNotWorkIfCreateUserFailed() {
        fakeUser = FakeUserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        let fakeCustomResponse = FakeCustomResponse(user: fakeUser)
        UserAuthenticationServiceTest.fakeStorage.append(fakeCustomResponse)
        authenticationService.createUserWithInformations("Victor", "Giron", "vg@outlook.fr", "1234") { (result) in
            switch result {
            case .success(_):

                let customResult = CustomResponse(user: UserDetails(email: "vg@outook.fr", firstName: "Victor", name: "Giron", userId: "3XDFR45GT", projects: nil))
                self.authenticationService.storeUser(customResult, firstName: "Victor", "Giron") { (storeResult) in
                    switch storeResult {
                    case .success(let void):
                        XCTAssertNil(void)
                    case .failure(let error):
                        XCTAssertNotNil(error)
                    }
                }
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

//    //MARK: - Test Storage

    func testStorageShouldWorkIfCorrectAndNewUser() {
        fakeUser = FakeUserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        let fakeCustomResponse = FakeCustomResponse(user: fakeUser)
        UserAuthenticationServiceTest.fakeStorage.append(fakeCustomResponse)
        authenticationService.createUserWithInformations("Victor", "Giron", "vg@outook.fr", "1234") { (result) in
            switch result {
            case .success(_):

                let customResult = CustomResponse(user: UserDetails(email: "vg@gmail.fr", firstName: "Victor", name: "Giron", userId: "3XDFLKLKLKR45GT", projects: nil))
                self.authenticationService.storeUser(customResult, firstName: "Victor", "Giron") { (storeResult) in
                    switch storeResult {
                    case .success(let void):
                        XCTAssertNotNil(void)
                    case .failure(let error):
                        XCTAssertNil(error)
                    }
                }
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testStorageShouldFailedIfCorrectAndNotNewUser() {
        fakeUser = FakeUserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        let fakeCustomReponse = FakeCustomResponse(user: fakeUser)
        UserAuthenticationServiceTest.fakeStorage.append(fakeCustomReponse)
        let customResponse = CustomResponse(user: UserDetails(email: "vg@outlook.fr", firstName: "Victor", name: "Giron", userId: "3XDFR45GT", projects: nil))
        self.authenticationService.storeUser(customResponse, firstName: "Victor", "Giron") { result in
            switch result {
            case .success(let void):
                XCTAssertNil(void)
                
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

    //Fetch

    func testFetchUSerShouldSucceedIfCorrectUserAsker() {
        fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)
//        let fakeCustomResponse = FakeCustomResponse(user: fakeUser)
//        fakeStorage.append(fakeCustomResponse)

        authenticationService.getUserData { result in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user)
                XCTAssertEqual(user?.user.userId, self.fakeUser.userId)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }

    }

    func testFetchUserShouldFailedIfIncorrectUserAsker() {
        fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyuiop", projects: nil)

        authenticationService.getUserData { result in
            switch result {
            case .success(let user):
                XCTAssertNil(user)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

    func testFetchProjectShouldSucceedIfTheirIsProject() {

            let fakeTask1 = FakeTask(title: "Test", projectID: "AZERTY", taskID: "AZERTYUi", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: false)
            let fakeProject1 = FakeProject(title: "Test", projectID: "AZERTY", description: "Something", ownerUserId: "azerty", isPersonal: true, downloadUrl: nil, taskList: [fakeTask1])
            let fakeProject2 = FakeProject(title: "anotherTest", projectID: "AZERTYU", description: "Something", ownerUserId: "azerty", isPersonal: true, downloadUrl: nil, taskList: nil)
        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [fakeProject1,fakeProject2])))

            let task1 = Task(title: "Test", projectID: "AZERTY", taskID: "AZERTYUi", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: false)
            let project1 = Project(title: "Test", projectID: "AZERTY", description: "Something", ownerUserId: "azerty", isPersonal: true, downloadUrl: nil, taskList: [task1])
            let project2 = Project(title: "anotherTest", projectID: "AZERTYU", description: "Something", ownerUserId: "azerty", isPersonal: true, downloadUrl: nil, taskList: nil)
            let projectList = [project1, project2]
        let user = CustomResponse(user: UserDetails(email: "test@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: projectList))
        fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [fakeProject1, fakeProject2])

        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: fakeUser))

        authenticationService.fetchProjects(user) { result in
            switch result {
            case .success(let projectList):
                XCTAssertNotNil(projectList)

            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    func testFetchProjectShouldFailedIfNoProject() {

        let projectList = [Project]()
        fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [])
        let user = CustomResponse(user: UserDetails(email: "test@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: projectList))

        UserAuthenticationServiceTest.fakeStorage.append(FakeCustomResponse(user: fakeUser))
        authenticationService.fetchProjects(user) { result in
            switch result {
            case .success(let projectList):
                XCTAssertNil(projectList)

            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

    func testUpdateUserShouldWorkIfExistingAndCorrectUser() {
        fakeUser = FakeUserDetails(email: "updatedEmail@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [])
        let user = CustomResponse(user: UserDetails(email: "updatedEmail@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: []))
        guard let firstName = fakeUser.firstName,
              let name = fakeUser.name,
              let email = fakeUser.email else {return}
        authenticationService.updateUser(user.user, firstName, name, email) { error in
            if error != nil {
                XCTAssertNotNil(error)
            } else {
                for user in UserAuthenticationServiceTest.fakeStorage {
                    if user.user.userId == self.fakeUser.userId {
                       return XCTAssertEqual(user.user.email, self.fakeUser.email)
                    }
                }
                XCTAssertNil(error)
            }
        }
    }

    func testUpdateUserShouldFailedIfInCorrectUserID() {
        fakeUser = FakeUserDetails(email: "updatedEmail@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [])
        let user = CustomResponse(user: UserDetails(email: "updatedEmail@outlook.fr", firstName: "test", name: "unit", userId: "aaaaa", projects: []))
        guard let firstName = fakeUser.firstName,
              let name = fakeUser.name,
              let email = fakeUser.email else {return}
        authenticationService.updateUser(user.user, firstName, name, email) { error in
            if error != nil {
                XCTAssertNotNil(error)
            } else {
                XCTAssertNil(error)
            }
        }
    }
    
    //Delete
    
    func testDeleteUserShouldWorkIfCorrectUser() {
        fakeUser = FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)
        let user = UserDetails(email: "test0@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: nil)
        self.authenticationService.deleteUser(user) { error in
                XCTAssertNil(error)
            
        }
    }
    
    func testDeleteUserShouldFailedIfNotCorrectUser() {
        fakeUser = FakeUserDetails(email: "unregistred@gmail.com", password: nil, firstName: "test", name: "unit", userId: "ACJZFJ345FNE", projects: nil)
        let user = UserDetails(email: "unregistred@gmail.com", firstName: "test", name: "unit", userId: "ACJZFJ345FNE", projects: nil)
        self.authenticationService.deleteUser(user) { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testLogoutShouldSucceedIfCorrectUser() {
        fakeUser = FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)
        let isDisconnected = self.authenticationService.logOut()
        XCTAssertEqual(isDisconnected, true)
    }
    
    func testLogoutShouldFailedIfNotCorrectUser() {
        fakeUser = FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "FJLDNED", projects: nil)
        let isDisconnected = self.authenticationService.logOut()
        XCTAssertEqual(isDisconnected, false)
    }

}

