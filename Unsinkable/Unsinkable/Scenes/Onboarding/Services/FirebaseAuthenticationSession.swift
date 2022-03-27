//
//  FirebaseAuthenticationSession.swift
//  Unsinkable
//
//  Created by Thomas on 25/02/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFunctions

class FirebaseAuthenticationSession {
    
    lazy var functions = Functions.functions()
    lazy var keyChainManager = KeyChainManager()
    
    //Use FireAuth to login user
    func signInRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (dataResponse, error) in
            if error != nil {
                guard let error = error else {return}
                return completion(nil, self.convertAuthErrorToUnsinkableError(error))
                
            }
            guard let user = dataResponse?.user else {
                return completion(nil, UnsinkableError.unknowError)
            }
            let customUser = CustomResponse(user: UserDetails(userId: user.uid, projects: nil))
            
            return completion(customUser, nil)
        }
    }
    
    //Use FireAuth to register a new user, store user credential in KeyChainManager to reauthenticate user without asking him to login manualy
    func createUserRequest(_ email: String, _ password: String, completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (dataResponse, error) in
            if error != nil {
                guard let error = error else {return}
                return completion(nil, self.convertAuthErrorToUnsinkableError(error))
            }
            guard let user = dataResponse?.user else {
                return completion(nil, UnsinkableError.unknowError)
            }
            let customUser = CustomResponse(user: UserDetails(userId: user.uid))
            
            //Store user credential in KeyChainManager
            self.keyChainManager.registerUserCredential(customUser.user, password)
            completion(customUser,nil)
        }
    }
    
    //Use firAuth to update current user, use firestore to update new user data in database, database ref match database struct to update the right file
    func updateUser(_ user: UserDetails?, _ firstName: String,_ name: String,_ email: String, completion: @escaping (UnsinkableError?) -> Void) {
        let auth = Auth.auth()
        guard let currentUser = auth.currentUser else {return}
        let currentEmail = currentUser.email
        let userId = currentUser.uid
        let database = Firestore.firestore()
        let databaseRef = database.collection(Constants.Database.User.userPath).document("\(userId)")
        
        //Update DB
        databaseRef.updateData([
            Constants.Database.User.firstNameField: firstName,
            Constants.Database.User.nameField: name,
        ]) { error in
            if error != nil {
                return completion(UnsinkableError.databaseCantUpdate)
            } else {
                if email != currentEmail {
                    guard let user = user else {return}
                    guard let userEmail = auth.currentUser?.email, let password = self.keyChainManager.getUserCredential(user) else {return}
                    let credential = EmailAuthProvider.credential(withEmail: userEmail, password: password)
                    currentUser.reauthenticate(with: credential) { (result, error) in
                        if error != nil {
                            guard let error = error else {return}
                            return completion(self.convertAuthErrorToUnsinkableError(error))
                        } else {
                            
                            //Update Authentication
                            currentUser.updateEmail(to: email) { error in
                                if error != nil {
                                    guard let error = error else {return}
                                    return completion(self.convertAuthErrorToUnsinkableError(error))
                                } else {
                                    return completion(nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Use user credential store in KeyChain manager to reauthenticate user, use FireUser to delete user
    func deleteUser(_ user: UserDetails, completion : @escaping (UnsinkableError?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {return}
        guard let email = currentUser.email, let password = keyChainManager.getUserCredential(user) else {return}
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        //Sensible operation need recent authentication
        currentUser.reauthenticate(with: credential) { result, error in
            if error != nil {
                guard let error = error else {return}
                return completion(self.convertAuthErrorToUnsinkableError(error))
            } else {
                
                //Delete user
                currentUser.delete { error in
                    if error != nil {
                        guard let error = error else {return}
                        return completion(self.convertAuthErrorToUnsinkableError(error))
                    } else {
                        if self.keyChainManager.deleteKey(user) == true {
                            return completion(nil)
                        } else {
                            return completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    // Use firestore + document ref matching dataBase  struct to add unser to database
    func addUserToDataBase(customResponse: CustomResponse?,_ firstName: String, _ name: String, completion: @escaping (UnsinkableError?) -> Void) {
        guard let userId = customResponse?.user.userId else { return }
        let dataBase = Firestore.firestore()
        let documentRef = dataBase.collection(Constants.Database.User.userPath).document(userId)
        documentRef.setData([
                                Constants.Database.User.firstNameField : firstName,
                                Constants.Database.User.nameField: name,
                                Constants.Database.User.uidField: userId])
        { (error) in
            if error != nil {
                return completion(UnsinkableError.databaseCantStoreUser)
            }
            return completion(nil)
        }
    }
    
    //Fetch user from firestoreData to local Data 
    func fetchUserFirestoreData(completion: @escaping (CustomResponse?, UnsinkableError?) -> Void) {
        var user = CustomResponse(user: UserDetails() )
        guard let data = Auth.auth().currentUser else {
            return
        }
        guard let email = data.email else {return}
        
        let database = Firestore.firestore()
        let documentRef = database.collection(Constants.Database.User.userPath).document("\(data.uid)")
        documentRef.getDocument { (documentSnapshot, error) in
            if error != nil {
                return completion(nil, UnsinkableError.databaseCantFetchUserData)
            } else {
                if let document = documentSnapshot, document.exists {
                    guard let data = document.data() else {
                        return
                    }
                    
                    let firstname = data[Constants.Database.User.firstNameField] as? String ?? ""
                    let name = data[Constants.Database.User.nameField] as? String ?? ""
                    let uid = data[Constants.Database.User.uidField] as? String ?? ""
                    user = CustomResponse(user: UserDetails(email: email, firstName: firstname, name: name, userId: uid, projects: []))
                    return completion(user,nil)
                }
            }
        }
    }
    //Use firestore to fetch all user project at specify path
    func fetchProjects(_ userData: CustomResponse?, completion: @escaping ([Project?]?, UnsinkableError?) -> Void) {
        guard let userId = userData?.user.userId else {
            return
        }
        
        var projectList = [Project?]()
        var taskList = [Task?]()
        let dataBase = Firestore.firestore()
        var projectIndex = 0
        
        //Document ref
        let documentRef = dataBase.collection(Constants.Database.User.userPath).document(userId).collection(Constants.Database.Project.projectPath)
        documentRef.getDocuments() { (querySnapshot, error) in
            if error != nil {
                completion(nil, UnsinkableError.databaseCantFetchData)
                return
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
                            //Can't fetch task
                            completion(nil, UnsinkableError.databaseCantFetchTask)
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
                        if projectList.count == queryArray.count{
                           return completion(projectList, nil)
                        }
                    }
                }
                completion([], nil)
            }
        }
    }
    
    //use to convert error from api to Custom error
    private func convertAuthErrorToUnsinkableError(_ error: Error) -> UnsinkableError {
        guard let error = error as NSError? else {
            return UnsinkableError.unknowError
        }
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return UnsinkableError.unknowError
        }
        return handleErrorWith(errorCode)
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

