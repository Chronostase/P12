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
//    var fakeUser: FakeUserDetails!
    var authenticationSessionFake: AuthenticationSessionFake?
    var authenticationService: UserAuthenticationService?
    
    override func setUp() {
        super.setUp()
        setupData()
    }
    
    override func tearDown() {
        super.tearDown()
        resetData()
    }
    
    private func setupData() {
        authenticationSessionFake = AuthenticationSessionFake()
        authenticationService = UserAuthenticationService(session: authenticationSessionFake!)
        authenticationSessionFake?.fakeUser = FakeUserDetails()
        authenticationSessionFake?.database.users = []
    }
    
    private func resetData() {
        authenticationSessionFake = nil
        authenticationService = nil
        
    }
    
    // MARK: - Test Login
    
    func testLoginShouldSucceedIfCorrectUserEmailAndPassword() {
        // Given
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "jean@email.fr", password: "1234")

        //When
        authenticationService?.loginUser("jean@email.fr", "1234") { (result) in

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
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "jean@email.fr", password: "1234")

        //When
        authenticationService?.loginUser("jean@email.fr", "134") { (result) in
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
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "jean@email.fr", password: "1234")
        //When
        authenticationService?.loginUser("jean@mail.fr", "1234") { (result) in
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
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "jean@email.fr", password: "1234", userId: "3x12fbdg")
        authenticationService?.createUserWithInformations("Jean", "Dujardin", "jean@email.fr", "1234") { (result) in
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

    func testShouldWorkIfCreateUserSuccessAndStoredUserSuccess() {
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        authenticationSessionFake?.database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "jpp@outlook.fr", password: "12345", userId: "ARGJB1857NFJ")))
        authenticationService?.createUserWithInformations("Victor", "Giron", "vg@outook.fr", "1234") { (result) in
            switch result {
            case .success(_):
                let customResult = CustomResponse(user: UserDetails(email: "vg@outook.fr", firstName: "Victor", name: "Giron", userId: "3XDFR45GT", projects: nil))

                self.authenticationService?.storeUser(customResult, firstName: "Victor", "Giron") { (storeResult) in
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
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        guard let customResponse = authenticationSessionFake?.fakeUser else {return}
        let fakeCustomResponse = FakeCustomResponse(user: customResponse)
        authenticationSessionFake?.database.users?.append(fakeCustomResponse)
        authenticationService?.createUserWithInformations("Victor", "Giron", "vg@outlook.fr", "1234") { (result) in
            switch result {
            case .success(_):

                let customResult = CustomResponse(user: UserDetails(email: "vg@outook.fr", firstName: "Victor", name: "Giron", userId: "3XDFR45GT", projects: nil))
                self.authenticationService?.storeUser(customResult, firstName: "Victor", "Giron") { (storeResult) in
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
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        guard let customResponse = authenticationSessionFake?.fakeUser else {return}
        let fakeCustomResponse = FakeCustomResponse(user: customResponse)
        authenticationSessionFake?.database.users?.append(fakeCustomResponse)
        authenticationService?.createUserWithInformations("Victor", "Giron", "vg@outook.fr", "1234") { (result) in
            switch result {
            case .success(_):

                let customResult = CustomResponse(user: UserDetails(email: "vg@gmail.fr", firstName: "Victor", name: "Giron", userId: "3XDFLKLKLKR45GT", projects: nil))
                self.authenticationService?.storeUser(customResult, firstName: "Victor", "Giron") { (storeResult) in
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
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "vg@outlook.fr", password: "1234", userId: "3XDFR45GT")
        guard let newFakeUser = authenticationSessionFake?.fakeUser else {return}
        let fakeCustomReponse = FakeCustomResponse(user: newFakeUser)
        authenticationSessionFake?.database.users?.append(fakeCustomReponse)
        let customResponse = CustomResponse(user: UserDetails(email: "vg@outlook.fr", firstName: "Victor", name: "Giron", userId: "3XDFR45GT", projects: nil))
        self.authenticationService?.storeUser(customResponse, firstName: "Victor", "Giron") { result in
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
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)
//        let fakeCustomResponse = FakeCustomResponse(user: fakeUser)
//        fakeStorage.append(fakeCustomResponse)

        authenticationService?.getUserData { result in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user)
                guard let newFakeUser = self.authenticationSessionFake?.fakeUser else {return}
                XCTAssertEqual(user?.user.userId, newFakeUser.userId)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }

    }

    func testFetchUserShouldFailedIfIncorrectUserAsker() {
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azertyuiop", projects: nil)

        authenticationService?.getUserData { result in
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
        authenticationSessionFake?.database.users?.append(FakeCustomResponse(user: FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [fakeProject1,fakeProject2])))

            let task1 = Task(title: "Test", projectID: "AZERTY", taskID: "AZERTYUi", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: false)
            let project1 = Project(title: "Test", projectID: "AZERTY", description: "Something", ownerUserId: "azerty", isPersonal: true, downloadUrl: nil, taskList: [task1])
            let project2 = Project(title: "anotherTest", projectID: "AZERTYU", description: "Something", ownerUserId: "azerty", isPersonal: true, downloadUrl: nil, taskList: nil)
            let projectList = [project1, project2]
        let user = CustomResponse(user: UserDetails(email: "test@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: projectList))
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [fakeProject1, fakeProject2])
        guard let customResponse = authenticationSessionFake?.fakeUser else {return}
        
        authenticationSessionFake?.database.users?.append(FakeCustomResponse(user: customResponse))

        authenticationService?.fetchProjects(user) { result in
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
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [])
        let user = CustomResponse(user: UserDetails(email: "test@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: projectList))
        
        
        guard let customResponse = authenticationSessionFake?.fakeUser else {return}

        authenticationSessionFake?.database.users?.append(FakeCustomResponse(user: customResponse))
        authenticationService?.fetchProjects(user) { result in
            switch result {
            case .success(let projectList):
                XCTAssertNil(projectList)

            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

    func testUpdateUserShouldWorkIfExistingAndCorrectUser() {
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "updatedEmail@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [])
        let user = CustomResponse(user: UserDetails(email: "updatedEmail@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: []))
        guard let firstName = authenticationSessionFake?.fakeUser?.firstName,
              let name = authenticationSessionFake?.fakeUser?.name,
              let email = authenticationSessionFake?.fakeUser?.email else {return}
        authenticationService?.updateUser(user.user, firstName, name, email) { error in
            if error != nil {
                XCTAssertNotNil(error)
            } else {
                guard let usersArray = self.authenticationSessionFake?.database.users else {return}
                for user in usersArray {
                    if user.user.userId == self.authenticationSessionFake?.fakeUser?.userId {
                        return XCTAssertEqual(user.user.email, self.authenticationSessionFake?.fakeUser?.email)
                    }
                }
                XCTAssertNil(error)
            }
        }
    }

    func testUpdateUserShouldFailedIfInCorrectUserID() {
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "updatedEmail@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [])
        let user = CustomResponse(user: UserDetails(email: "updatedEmail@outlook.fr", firstName: "test", name: "unit", userId: "aaaaa", projects: []))
        guard let firstName = authenticationSessionFake?.fakeUser?.firstName,
              let name = authenticationSessionFake?.fakeUser?.name,
              let email = authenticationSessionFake?.fakeUser?.email else {return}
        authenticationService?.updateUser(user.user, firstName, name, email) { error in
            if error != nil {
                XCTAssertNotNil(error)
            } else {
                XCTAssertNil(error)
            }
        }
    }
    
    //Delete
    
    func testDeleteUserShouldWorkIfCorrectUser() {
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)
        let user = UserDetails(email: "test0@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: nil)
        self.authenticationService?.deleteUser(user) { error in
                XCTAssertNil(error)
            
        }
    }
    
    func testDeleteUserShouldFailedIfNotCorrectUser() {
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "unregistred@gmail.com", password: nil, firstName: "test", name: "unit", userId: "ACJZFJ345FNE", projects: nil)
        let user = UserDetails(email: "unregistred@gmail.com", firstName: "test", name: "unit", userId: "ACJZFJ345FNE", projects: nil)
        self.authenticationService?.deleteUser(user) { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testLogoutShouldSucceedIfCorrectUser() {
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: nil)
        let isDisconnected = self.authenticationService?.logOut()
        XCTAssertEqual(isDisconnected, true)
    }
    
    func testLogoutShouldFailedIfNotCorrectUser() {
        authenticationSessionFake?.fakeUser = FakeUserDetails(email: "test0@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "FJLDNED", projects: nil)
        let isDisconnected = self.authenticationService?.logOut()
        XCTAssertEqual(isDisconnected, false)
    }

}

