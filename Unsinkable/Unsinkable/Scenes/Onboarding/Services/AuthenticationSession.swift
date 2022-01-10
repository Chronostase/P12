//
//  AuthenticationSession.swift
//  Unsinkable
//
//  Created by Thomas on 25/02/2021.
//

import Foundation
import Firebase
import FirebaseFunctions

class AuthenticationSession {
    
    lazy var functions = Functions.functions()
    lazy var keyChainManager = KeyChainManager()
    
    func signInRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (dataResponse, error) in
            guard let user = dataResponse?.user else {
                
                return completion(nil,error)
            }
            let customUser = CustomResponse(user: UserDetails(email: user.email, password: user.displayName, userId: user.uid, projects: nil))
            
            completion(customUser, error)
        }
    }
    
    func createUserRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (dataResponse, error) in
            
            guard let user = dataResponse?.user else {
                
                return completion(nil,error)
            }
            let customUser = CustomResponse(user: UserDetails(email: user.email, userId: user.uid))
            self.keyChainManager.registerUserCredential(customUser.user, password)
            completion(customUser,error)
        }
    }
    
    func updateUser(_ user: UserDetails?, _ firstName: String,_ name: String,_ email: String, completion: @escaping (Error?) -> Void) {
        let auth = Auth.auth()
        guard let currentUser = auth.currentUser else {return}
        let currentEmail = currentUser.email
        let userId = currentUser.uid
        let database = Firestore.firestore()
        let databaseRef = database.collection(Constants.Database.User.userPath).document("\(userId)")
        #warning("Need to be second if Email succeed")
        databaseRef.updateData([
            Constants.Database.User.firstNameField: firstName,
            Constants.Database.User.nameField: name,
            Constants.Database.User.emailField: email
        ]) { error in
            if error != nil {
                completion(error)
            } else {
                #warning("need to be first probably reauthenticate to solve email problem")
                if email != currentEmail {
                    guard let user = user else {return}
                    guard let userEmail = auth.currentUser?.email, let password = self.keyChainManager.getUserCredential(user) else {return}
                    let credential = EmailAuthProvider.credential(withEmail: userEmail, password: password)
                    currentUser.reauthenticate(with: credential) { (result, error) in
                        if error != nil {
                            completion(error)
                        } else {
                            currentUser.updateEmail(to: email) { error in
                                if error != nil {
                                    //Email not change
                                    completion(error)
                                } else {
                                    completion(nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func deleteUser(_ user: UserDetails, completion : @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {return}
        guard let email = user.email, let password = keyChainManager.getUserCredential(user) else {return}
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        currentUser.reauthenticate(with: credential) { result, error in
            if error != nil {
                completion(error)
            } else {
                currentUser.delete { error in
                    if error != nil {
                        completion(error)
                    } else {
                        if self.keyChainManager.deleteKey(user) == true {
                            print("Successfuly delete keychain ref")
                            completion(nil)
                        } else {
                            print("Key chain failed to delete reference")
                            completion(error)
                        }
                    }
                }
            }
        }
    }
    
    func addUserToDataBase(customResponse: CustomResponse?,_ firstName: String, _ name: String, _ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
        guard let userId = customResponse?.user.userId else { return }
        let dataBase = Firestore.firestore()
        let documentRef = dataBase.collection(Constants.Database.User.userPath).document(userId)
        documentRef.setData([
                                Constants.Database.User.firstNameField : firstName,
                                Constants.Database.User.nameField: name,
                                Constants.Database.User.emailField : email,
                                Constants.Database.User.uidField: userId])
        { (error) in
            if error != nil {
                guard let error = error else { return }
                completion(nil,error)
            }
            completion(customResponse,error)
        }
    }
    
    func fetchUserFirestoreData(completion: @escaping (CustomResponse?, Error?) -> Void) {
        var user = CustomResponse(user: UserDetails() )
        guard let data = Auth.auth().currentUser else {
            return
        }
        
        let database = Firestore.firestore()
        let documentRef = database.collection(Constants.Database.User.userPath).document("\(data.uid)")
        documentRef.getDocument { (documentSnapshot, error) in
            if error != nil {
                completion(nil, error)
            } else {
                if let document = documentSnapshot, document.exists {
                    guard let data = document.data() else {
                        return
                    }
                    
                    let firstname = data[Constants.Database.User.firstNameField] as? String ?? ""
                    let name = data[Constants.Database.User.nameField] as? String ?? ""
                    let uid = data[Constants.Database.User.uidField] as? String ?? ""
                    let email = data[Constants.Database.User.emailField] as? String ?? ""
                    user = CustomResponse(user: UserDetails(email: email, firstName: firstname, name: name, userId: uid, projects: []))
                    completion(user,nil)
                }
            }
        }
    }
    
    func fetchProjects(_ userData: CustomResponse?, completion: @escaping ([Project?]?, Error?) -> Void) {
        guard let userId = userData?.user.userId else {
            return
        }
        
        var projectList = [Project?]()
        var taskList = [Task?]()
        let dataBase = Firestore.firestore()
        var projectIndex = 0
        
        //Document ref to docu
        let documentRef = dataBase.collection(Constants.Database.User.userPath).document(userId).collection(Constants.Database.Project.projectPath)
        documentRef.getDocuments() { (querySnapshot, error) in
            if error != nil {
                guard let error = error else { return }
                completion(nil, error)
            } else {
                guard let queryArray = querySnapshot?.documents else { return }
                for document in queryArray {
                    projectIndex += 1
                    let data = document.data()
                    let projectTitle = data[Constants.Database.Project.title] as? String ?? ""
                    let projectID = data[Constants.Database.Project.id] as? String ?? ""
                    let projectDescription = data[Constants.Database.Project.description] as? String ?? ""
                    let ownerUserId = data[Constants.Database.Project.ownerID] as? String ?? ""
                    let isPersonal = data[Constants.Database.Project.isPersonal] as? Bool
                    let downloadUrl = data[Constants.Database.Project.downloadURL] as? String ?? ""
                    let tasksRef = dataBase.collection(Constants.Database.User.userPath).document(userId).collection(Constants.Database.Project.projectPath).document(projectID).collection(Constants.Database.Task.taskPath)
                    tasksRef.getDocuments() { (querys, error) in
                        if error != nil {
                            guard let error = error else {return}
                            completion(nil, error)
                        } else {
                            guard let taskQueryArray = querys?.documents else {return}
                            for document in taskQueryArray {
                                let data = document.data()
                                let taskTitle = data[Constants.Database.Task.title] as? String ?? ""
                                let projectID = data[Constants.Database.Task.projectID] as? String ?? ""
                                let taskID = data[Constants.Database.Task.id] as? String ?? ""
                                let taskPriority = data[Constants.Database.Task.priority] as? Bool ?? nil
                                let taskDeadLine = data[Constants.Database.Task.deadLine] as? Timestamp
                                let taskCommentary = data[Constants.Database.Task.commentary] as? String ?? ""
                                let taskLocation = data[Constants.Database.Task.location] as? String ?? ""
                                let isValidate = data[Constants.Database.Task.isValidate] as? Bool ?? false
                                let date = taskDeadLine?.dateValue()
                                let task = Task(title: taskTitle, projectID: projectID, taskID: taskID, priority: taskPriority, deadLine: date, commentary: taskCommentary, location: taskLocation, isValidate: isValidate)
                                taskList.append(task)
                            }
                        }
                        let project = Project(title: projectTitle, projectID: projectID ,description: projectDescription, ownerUserId: ownerUserId, isPersonal: isPersonal, downloadUrl: downloadUrl, taskList: taskList)
                        projectList.append(project)
                        taskList.removeAll()
                        print(taskList.count)
                        if projectList.count == queryArray.count{
                            completion(projectList, nil)
                        }
                    }
                }
                completion([], nil)
            }
        }
    }
    
    func logOutUser() -> Bool {
        let fireAuth = Auth.auth()
        do {
            try fireAuth.signOut()
            return true
        }
        catch let signOutError as NSError {
            print(signOutError)
            return false
        }
    }
    
    func isCurrentUserLogin() -> Bool {
        guard let _ = Auth.auth().currentUser else {
            return false
        }
        return true
    }
}
