//
//  ProjectSession.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFunctions

class ProjectSession {
    
    #warning("Take care description can be optional + Bug happend when user tip task name without validation and save project")
    #warning("Reload tableView in project reader happed when delete task ")
    
    lazy var functions = Functions.functions()
    lazy var keyChainManager = KeyChainManager()
    
    func updateTask(_ project: Project?,_ task: Task?, _ userData: CustomResponse?, completion: @escaping (Error?) -> Void) {
        guard let project = project else {return}
        guard let projectTitle = project.title else {return}
        guard let userId = userData?.user.userId else {return}
        guard let ownerId = project.ownerUserId else {return}
        guard let task = task else {return}
        guard let taskTitle = task.title else {return}
        guard let user = userData?.user else {return}
        guard let currentUser = Auth.auth().currentUser, let email = userData?.user.email else {return}
        guard let password = keyChainManager.getUserCredential(user) else {return}
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        let database = Firestore.firestore()
        let taskRef = database.collection("Users").document(userId).collection("Projects").document(projectTitle).collection("Tasks").document(taskTitle)
        currentUser.reauthenticate(with: credential) { (nil, error) in
            if error != nil {
                completion(error)
            } else {
                if userId == ownerId {
                    taskRef.updateData([
                        "title": taskTitle,
                        "location": task.location ?? "",
                        "taskCommentary": task.commentary ?? "",
                        "taskDeadLine": task.deadLine ?? "",
                        "taskPriority": task.priority ?? ""
                    ]) { error in
                        if error != nil {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                } else {
                    //Operation not allow
                    completion(nil)
                }
            }
        }
        
    }
    
    func updateProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (Error?) -> Void) {
        
        guard let project = project else { return }
        guard let userId = userData?.user.userId else {return}
        guard let ownerId = project.ownerUserId else {return}
        guard let title = project.title else { return }
        guard let description = project.description else { return }
        guard let projectID = project.projectID else { return }
        guard let isPersonal = project.isPersonal else {return}
        
        let storageRef = Storage.storage().reference().child("Users/\(ownerId)/\(projectID).jpeg")
        if userId == ownerId {
            
            //Delete old cover picture
            
            storageRef.delete { error in
                if error != nil {
                    completion(error)
                } else {
                    guard let coverData = coverPicture else {return}
                    
                    //Handle download Url
                    
                    storageRef.putData(coverData, metadata: nil) { (_, error) in
                        if error != nil {
                            completion(error)
                        } else {
                            storageRef.downloadURL { url, error in
                                if error != nil {
                                    completion(error)
                                } else {
                                    
                                    //Update project in database
                                    
                                    let database = Firestore.firestore()
                                    guard let url = url?.absoluteString else {return}
                                    let projectRef = database.collection("Users").document(userId).collection("Projects").document(title)
                                    projectRef.updateData([
                                        "Title": title,
                                        "Description": description,
                                        "ownerUserId": userId,
                                        "projectId": projectID,
                                        "isPersonal": isPersonal,
                                        "downloadUrl": url
                                    ]) { error in
                                        if error != nil {
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

        }
    }
    
    func registerUserProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (CustomResponse?, Error?) -> Void) {
        guard let userId = userData?.user.userId else {
            return
        }
        guard let project = project else { return }
        guard let ownerId = project.ownerUserId else {return}
        guard let title = project.title else { return }
        guard let description = project.description else { return }
        guard let projectID = project.projectID else { return }
        guard let isPersonal = project.isPersonal else {return}
        
        
        let dataBase = Firestore.firestore()
        let storageRef = Storage.storage().reference().child("Users/\(ownerId)/\(projectID).jpeg")
        //        let storageRef = Storage.storage().reference().child("ProjectsImages/\(imageID)")
        if let coverPictureData = coverPicture {
            storageRef.putData(coverPictureData, metadata: nil) { _ , error in
                print("Enter In storage.putData")
                if error != nil {
                    print("Error while uploading image")
                    return
                } else {
                    
                    storageRef.downloadURL { URL, error in
                        if error != nil {
                            print("Error to recover URL")
                            return
                        } else {
                            guard let url = URL?.absoluteString else {return}
                            let documentData: [String: Any] = [
                                "Title": title,
                                "Description": description,
                                "ownerUserId": userId,
                                "projectId": projectID,
                                "isPersonal": isPersonal,
                                "downloadUrl": url
                            ]
                            
                            let documentRef = dataBase.collection("Users").document(userId).collection("Projects").document(title)
                            
                            documentRef.setData(documentData)
                            { (error) in
                                if error != nil {
                                    guard let error = error else {
                                        return
                                    }
                                    //Error
                                    completion(nil,error)
                                }
                                //Succeed
                                completion(nil,error)
                            }
                        }
                    }
                }
                print("Exit put Data completion")
            }
        } else {
            print("No image to register")
        }
        print("END PROJECT REGISTRATION")
    }
    
    func registerUserTask(_ tasks: [Task?]?,_ project: Project?, completion: @escaping (CustomResponse?, Error?) -> Void) {
        
        let database = Firestore.firestore()
        guard let tasks = tasks else {return}
        guard let userID = project?.ownerUserId else {return}
        guard let projectID = project?.projectID else {return}
        guard let projectTitle = project?.title else {return}
        
        for task in tasks {
            guard let task = task else {return}
            guard let taskTitle = task.title else {return}
            guard let taskID = task.taskID else {return}
            var timeStamp: Timestamp?
            if let date = task.deadLine {
                timeStamp = Timestamp(date: date)
            } else {
                timeStamp = nil
            }
            let documentData: [String: Any] = [
                "title" : taskTitle,
                "projectID" : projectID,
                "taskID" : taskID,
                "taskPriority" : task.priority ?? false,
                "taskDeadLine" :  timeStamp ?? "",
                "taskCommentary" : task.commentary ?? "",
                "location" : task.location ?? ""
            ]
            let documentRef = database.collection("Users").document(userID).collection("Projects").document(projectTitle).collection("Tasks").document(taskTitle)
            
            documentRef.setData(documentData) { error in
                if error != nil {
                    guard let error = error else {return}
                    completion(nil, error)
                }
                completion(nil, error)
            }
        }
    }
    
    func deleteAllUserRef(_ user: CustomResponse?, completion: @escaping (Error?) -> Void) {
        guard let user = user, let userId = user.user.userId else {return}
        guard let token = Keys.value(for: Constants.Token.cloudToken) else {
            return
        }
        let database = Firestore.firestore()
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Users/\(userId)/")
        let databaseRef = database.collection("Users").document(userId)
        let deleteDatabaseFn = functions.httpsCallable("recursiveDelete")
        let data: [String: Any] = [
            "path": databaseRef.path,
            "token": token
        ]
        //Delete userRef in storage
        
        storageRef.listAll { storageList, error in
            if error != nil {
                completion(error)
            } else {
                
                if storageList.items.count > 0 {
                    let _ = storageList.items.map { item in
                        item.delete { error in
                            if error != nil {
                                completion(error)
                            } else {
                                //Delete userRef in database
                                //Maybe is needed to check if user have project
                                deleteDatabaseFn.call(data) { (result, error)  in
                                    if let error = error as NSError? {
                                        if error.domain == FunctionsErrorDomain {
                                            let code = FunctionsErrorCode(rawValue: error.code)
                                            let message = error.localizedDescription
                                            let details = error.userInfo[FunctionsErrorDetailsKey]
                                            print("code \(code)")
                                            print("message \(message)")
                                            print("details \(details)")
                                        }
                                        completion(error)
                                    } else {
                                        completion(nil)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    deleteDatabaseFn.call(data) { (result, error)  in
                        if let error = error as NSError? {
                            if error.domain == FunctionsErrorDomain {
                                let code = FunctionsErrorCode(rawValue: error.code)
                                let message = error.localizedDescription
                                let details = error.userInfo[FunctionsErrorDetailsKey]
                                print("code \(code)")
                                print("message \(message)")
                                print("details \(details)")
                            }
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func deleteUserProject(_ project: Project?, completion: @escaping (Error?) -> Void) {
        guard let project = project else {return}
        guard let projectTitle = project.title else {return}
        guard let userId = project.ownerUserId else {return}
        guard let token = Keys.value(for: Constants.Token.cloudToken) else {
            return 
        }
        
        let database = Firestore.firestore()
        let projectRef = database.collection("Users").document(userId).collection("Projects").document(projectTitle)
        let deleteFn = functions.httpsCallable("recursiveDelete")
        let data: [String: Any] = [
            "path": projectRef.path,
            "token": token
        ]
        
        deleteFn.call(data) { (result, error)  in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("code \(code)")
                    print("message \(message)")
                    print("details \(details)")
                }
                completion(error)
            } else {
                guard let projectId = project.projectID else {return}
                let storage = Storage.storage()
                let storageRef = storage.reference().child("Users/\(userId)/\(projectId).jpeg")
                storageRef.delete { error in
                    if error != nil {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func deleteUserTask(_ project: Project?,_ task: Task?, completion: @escaping (Error?) -> Void) {
        guard let project = project, let task = task else {return}
        guard let projectTitle = project.title else {return}
        guard let userId = project.ownerUserId else {return}
        guard let taskTitle = task.title else {return}
        guard let token = Keys.value(for: Constants.Token.cloudToken) else {
            return
        }
        
        let database = Firestore.firestore()
        let projectRef = database.collection("Users").document(userId).collection("Projects").document(projectTitle).collection("Tasks").document(taskTitle)
        let deleteFn = functions.httpsCallable("recursiveDelete")
        let data: [String: Any] = [
            "path": projectRef.path,
            "token": token
        ]
        deleteFn.call(data) { (result, error)  in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("code \(code)")
                    print("message \(message)")
                    print("details \(details)")
                }
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
