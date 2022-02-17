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
    var fakeUser: FakeUserDetails!
    var fakeStorage = [FakeCustomResponse]()
    var authenticationService: UserAuthentificationService {
        return UserAuthentificationService(session: AuthenticationSessionFake(fakeUser: fakeUser, fakeStorage: fakeStorage))
    }
    
    override func tearDown() {
        resetStorage()
        super.tearDown()
    }
    
    func resetStorage() {
        self.fakeStorage = []
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
        fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "jpp@outlook.fr", password: "12345", userId: "ARGJB1857NFJ")))
        authenticationService.createUserWithInformations("Victor", "Giron", "vg@outook.fr", "1234") { (result) in
            switch result {
            case .success(_):
                let customResult = CustomResponse(user: UserDetails(email: "vg@outook.fr", firstName: "Victor", name: "Giron", userId: "3XDFR45GT", projects: nil))
                
                self.authenticationService.storeUser(customResult, firstName: "Victor", "Giron") { (error) in
                    if error != nil {
                        XCTAssertNotNil(error)
                    } else {
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
        fakeStorage.append(fakeCustomResponse)
        authenticationService.createUserWithInformations("Victor", "Giron", "vg@outlook.fr", "1234") { (result) in
            switch result {
            case .success(_):
                
                let customResult = CustomResponse(user: UserDetails(email: "vg@outook.fr", firstName: "Victor", name: "Giron", userId: "3XDFR45GT", projects: nil))
                self.authenticationService.storeUser(customResult, firstName: "Victor", "Giron") { (error) in
                    if error != nil {
                        XCTAssertNotNil(error)
                    } else {
                        XCTAssertNil(error)
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
        fakeStorage.append(fakeCustomResponse)
        authenticationService.createUserWithInformations("Victor", "Giron", "vg@outook.fr", "1234") { (result) in
            switch result {
            case .success(_):
                
                let customResult = CustomResponse(user: UserDetails(email: "vg@gmail.fr", firstName: "Victor", name: "Giron", userId: "3XDFLKLKLKR45GT", projects: nil))
                self.authenticationService.storeUser(customResult, firstName: "Victor", "Giron") { (error) in
                    if error != nil {
                        XCTAssertNotNil(error)
                    } else {
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
        let fakeCustomResponse = FakeCustomResponse(user: fakeUser)
        fakeStorage.append(fakeCustomResponse)
        authenticationService.createUserWithInformations("Victor", "Giron", "vg@outook.fr", "1234") { (result) in
            switch result {
            case .success(_):
                
                let customResult = CustomResponse(user: UserDetails(email: "vg@gmail.fr", firstName: "Victor", name: "Giron", userId: "3XDFR45GT", projects: nil))
                self.authenticationService.storeUser(customResult, firstName: "Victor", "Giron") { (error) in
                    if error != nil {
                        print("HERREEEEEE")
                        XCTAssertNotNil(error)
                    } else {
                        XCTAssertNil(error)
                    }
                }
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
//        let fakeCustomResponse = FakeCustomResponse(user: fakeUser)
//        fakeStorage.append(fakeCustomResponse)
        
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
            fakeStorage.append(FakeCustomResponse(user: FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [fakeProject1,fakeProject2])))
        
            let task1 = Task(title: "Test", projectID: "AZERTY", taskID: "AZERTYUi", priority: true, deadLine: nil, commentary: nil, location: nil, isValidate: false)
            let project1 = Project(title: "Test", projectID: "AZERTY", description: "Something", ownerUserId: "azerty", isPersonal: true, downloadUrl: nil, taskList: [task1])
            let project2 = Project(title: "anotherTest", projectID: "AZERTYU", description: "Something", ownerUserId: "azerty", isPersonal: true, downloadUrl: nil, taskList: nil)
            let projectList = [project1, project2]
        let user = CustomResponse(user: UserDetails(email: "test@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: projectList))
        fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [fakeProject1, fakeProject2])
        
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
        #warning("Non sens, here testing user local project should be DB with track ownerID / projectID ")
        let projectList = [Project]()
        fakeUser = FakeUserDetails(email: "test@outlook.fr", password: nil, firstName: "test", name: "unit", userId: "azerty", projects: [])
        let user = CustomResponse(user: UserDetails(email: "test@outlook.fr", firstName: "test", name: "unit", userId: "azerty", projects: projectList))
        authenticationService.fetchProjects(user) { result in
            switch result {
            case .success(let projectList):
                XCTAssertNil(projectList)
                
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

}

