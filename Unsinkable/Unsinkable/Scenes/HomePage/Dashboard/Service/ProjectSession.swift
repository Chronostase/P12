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
    
    lazy var functions = Functions.functions()
    lazy var keyChainManager = KeyChainManager()
    
    //User firestore to refreshCurrentProject, projectRef and taskRef match with database path to reach the right files
    func refreshCurrentProject(_ project: Project?,_ userData: CustomResponse?, completion: @escaping (Project?, UnsinkableError?) -> Void) {
        guard let project = project else {return}
        guard let projectId = project.projectID else {return}
        guard let user = userData?.user, let userID = user.userId else {return}
        var taskList = [Task?]()
        
        let database = Firestore.firestore()
        let projectRef = database.collection(Constants.Database.User.userPath).document(userID).collection(Constants.Database.Project.projectPath).document(projectId)
        
        projectRef.getDocument { document, error in
            if error != nil {
                completion(nil,UnsinkableError.databaseCantFetchData)
            } else {
                guard let document = document else {return}
                if document.exists {
                    guard let data = document.data() else {return}
                    let projectTitle = data[Constants.Database.Project.title] as? String ?? ""
                    let projectID = data[Constants.Database.Project.id] as? String ?? ""
                    let projectDescription = data[Constants.Database.Project.description] as? String ?? ""
                    let ownerUserId = data[Constants.Database.Project.ownerID] as? String ?? ""
                    let isPersonal = data[Constants.Database.Project.isPersonal] as? Bool
                    let downloadUrl = data[Constants.Database.Project.downloadURL] as? String ?? ""
                    let tasksRef = projectRef.collection(Constants.Database.Task.taskPath)
                    
                    tasksRef.getDocuments { querysnapshot, error in
                        if error != nil {
                            completion(nil, UnsinkableError.databaseCantFetchTask)
                        } else {
                            guard let query = querysnapshot else {return}
                            for document in query.documents {
                                let data = document.data()
                                let taskTitle = data[Constants.Database.Task.title] as? String ?? ""
                                let projectID = data[Constants.Database.Task.projectID] as? String ?? ""
                                let taskID = data[Constants.Database.Task.id] as? String ?? ""
                                let taskPriority = data[Constants.Database.Task.priority] as? Bool ?? false
                                let taskDeadLine = data[Constants.Database.Task.deadLine] as? Timestamp
                                let taskCommentary = data[Constants.Database.Task.commentary] as? String ?? ""
                                let taskLocation = data[Constants.Database.Task.location] as? String ?? ""
                                let isValidate = data[Constants.Database.Task.isValidate] as? Bool ?? false
                                
                                let date = taskDeadLine?.dateValue()
                                let task = Task(title: taskTitle, projectID: projectID, taskID: taskID, priority: taskPriority, deadLine: date, commentary: taskCommentary, location: taskLocation, isValidate: isValidate)
                                taskList.append(task)
                            }
                            let project = Project(title: projectTitle, projectID: projectID ,description: projectDescription, ownerUserId: ownerUserId, isPersonal: isPersonal, downloadUrl: downloadUrl, taskList: taskList)
                            taskList.removeAll()
                            completion(project, nil)
                        }
                    }
                    
                } else {
                    completion(nil, UnsinkableError.databaseCantAccessToProject)
                }
            }
        }
    }
    //Unse firestore to update task statement, need to reauthenticate user for this operation that's why keyChainManager is used, taskPath is used to feat with database struc to access right files
    func updateValidateStatement(_ project: Project?, selectedTask: Task?, _ userData: CustomResponse?, completion: @escaping (Result<Void?, UnsinkableError>) -> Void) {
        guard let project = project,
              let task = selectedTask,
              let user = userData?.user else {return}
        guard let currentTaskID = task.taskID,
              let projectID = project.projectID,
              let userID = user.userId else {return}
        guard let currentUser = Auth.auth().currentUser, let email = currentUser.email else {return}
        guard let password = keyChainManager.getUserCredential(user) else {return}
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        let database = Firestore.firestore()
        let taskRef = database.collection(Constants.Database.User.userPath).document(userID).collection(Constants.Database.Project.projectPath).document(projectID).collection(Constants.Database.Task.taskPath).document(currentTaskID)
        currentUser.reauthenticate(with: credential) { (nil, error) in
            if error != nil {
                guard let error = error as NSError? else {
                    completion(.failure(UnsinkableError.unknowError))
                    return
                }
                guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                    completion(.failure(UnsinkableError.unknowError))
                    return
                }
                
                completion(.failure(self.handleAuthErrorWith(errorCode)))
            } else {
                taskRef.updateData([
                    Constants.Database.Task.isValidate: task.isValidate ?? false
                ]) { error in
                    if error != nil {
                        completion(.failure(UnsinkableError.databaseCantUpdateTask))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
        
    }
    
    //Firestore is use to update user task, keychain is here to reauthenticaten taskPath is use to feat with database struct to update right file
    func updateTask(_ project: Project?, currentTask: Task?, newTask: Task?, _ userData: CustomResponse?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let project = project else {return}
        guard let projectID = project.projectID else {return}
        guard let userId = userData?.user.userId else {return}
        guard let ownerId = project.ownerUserId else {return}
        
        guard let currentTask = currentTask else {return}
        guard let currentTaskId = currentTask.taskID else {return}
        guard let newTask = newTask else {return}
        
        guard let user = userData?.user else {return}
        guard let currentUser = Auth.auth().currentUser, let email = currentUser.email else {return}
        guard let password = keyChainManager.getUserCredential(user) else {return}
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        let database = Firestore.firestore()
        let taskRef = database.collection(Constants.Database.User.userPath).document(userId).collection(Constants.Database.Project.projectPath).document(projectID).collection(Constants.Database.Task.taskPath).document(currentTaskId)
        currentUser.reauthenticate(with: credential) { (nil, error) in
            if error != nil {
                guard let error = error as NSError? else {
                    completion(UnsinkableError.unknowError)
                    return
                }
                guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                    completion(UnsinkableError.unknowError)
                    return
                }
                
                completion(self.handleAuthErrorWith(errorCode))
            } else {
                if userId == ownerId {
                    taskRef.updateData([
                        Constants.Database.Task.title: newTask.title ?? "",
                        Constants.Database.Task.location: newTask.location ?? "",
                        Constants.Database.Task.commentary: newTask.commentary ?? "",
                        Constants.Database.Task.deadLine: newTask.deadLine ?? "",
                        Constants.Database.Task.priority: newTask.priority ?? "",
                        Constants.Database.Task.isValidate: newTask.isValidate ?? false
                    ]) { error in
                        if error != nil {
                            completion(UnsinkableError.databaseCantUpdateTask)
                        } else {
                            completion(nil)
                        }
                    }
                } else {
                    //Operation not allow
                    completion(UnsinkableError.operationNotAllowed)
                }
            }
        }
        
    }
    //Storage is used to replace cover picture and get new downloadUrl, firestore is use to update project with right path matching database struct
    func updateProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void) {
        
        guard let project = project else { return }
        guard let userId = userData?.user.userId else {return}
        guard let ownerId = project.ownerUserId else {return}
        guard let title = project.title else { return }
        guard let projectID = project.projectID else { return }
        guard let isPersonal = project.isPersonal else {return}
        
        let storageRef = Storage.storage().reference().child("Users/\(ownerId)/\(projectID).jpeg")
        if userId == ownerId {
            
            //Delete old cover picture
            if coverPicture != nil {
                storageRef.delete { error in
                    if error != nil {
                        guard let error = error else {
                            completion(UnsinkableError.unknowError)
                            return
                        }
                        completion(self.convertStorageErrorToUnsinkableError(error))
                        return
                    } else {
                        guard let coverData = coverPicture else {return}
                        
                        //Handle download Url
                        
                        storageRef.putData(coverData, metadata: nil) { (_, error) in
                            if error != nil {
                                guard let error = error else {
                                    completion(UnsinkableError.unknowError)
                                    return
                                }
                                completion(self.convertStorageErrorToUnsinkableError(error))
                            } else {
                                storageRef.downloadURL { url, error in
                                    if error != nil {
                                        guard let error = error else {
                                            completion(UnsinkableError.unknowError)
                                            return
                                        }
                                        completion(self.convertStorageErrorToUnsinkableError(error))
                                    } else {
                                        
                                        //Update project in database
                                        
                                        let database = Firestore.firestore()
                                        guard let url = url?.absoluteString else {return}
                                        let projectRef = database.collection(Constants.Database.User.userPath).document(userId).collection(Constants.Database.Project.projectPath).document(projectID)
                                        projectRef.updateData([
                                            Constants.Database.Project.title: title,
                                            Constants.Database.Project.description: project.description ?? "",
                                            Constants.Database.Project.ownerID: userId,
                                            Constants.Database.Project.id: projectID,
                                            Constants.Database.Project.isPersonal: isPersonal,
                                            Constants.Database.Project.downloadURL: url
                                        ]) { error in
                                            if error != nil {                           completion(UnsinkableError.databaseCantUpdate)
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
            } else {
                let database = Firestore.firestore()
                let projectRef = database.collection(Constants.Database.User.userPath).document(userId).collection(Constants.Database.Project.projectPath).document(projectID)
                projectRef.updateData([
                    Constants.Database.Project.title: title,
                    Constants.Database.Project.description: project.description ?? "",
                    Constants.Database.Project.ownerID: userId,
                    Constants.Database.Project.id: projectID,
                    Constants.Database.Project.isPersonal: isPersonal,
                ]) { error in
                    if error != nil {
                        completion(UnsinkableError.databaseCantUpdate)
                    } else {
                        completion(nil)
                    }
                }
            }
            
        }
    }
    
    //Firestore is use to register user project, with document ref we save it at specify place in DB, Storage is use to store coverPicture and get downloadUrl
    func registerUserProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let userId = userData?.user.userId else {
            return
        }
        guard let project = project else { return }
        guard let ownerId = project.ownerUserId else {return}
        guard let title = project.title else { return }
        guard let projectID = project.projectID else { return }
        guard let isPersonal = project.isPersonal else {return}
        
        
        let dataBase = Firestore.firestore()
        let storageRef = Storage.storage().reference().child("Users/\(ownerId)/\(projectID).jpeg")
        if let coverPictureData = coverPicture {
            
            //Save coverPicture in storage
            storageRef.putData(coverPictureData, metadata: nil) { _ , error in
                if error != nil {
                    completion(UnsinkableError.storageCantSaveImage)
                    return
                } else {
                    
                    //Handle downloardUrl
                    storageRef.downloadURL { URL, error in
                        if error != nil {
                            guard let error = error else {
                                completion(UnsinkableError.unknowError)
                                return
                            }
                            completion(self.convertStorageErrorToUnsinkableError(error))
                            return
                        } else {
                            guard let url = URL?.absoluteString else {return}
                            let documentData: [String: Any] = [
                                Constants.Database.Project.title: title,
                                Constants.Database.Project.description: project.description ?? "",
                                Constants.Database.Project.ownerID: userId,
                                Constants.Database.Project.id: projectID,
                                Constants.Database.Project.isPersonal: isPersonal,
                                Constants.Database.Project.downloadURL: url
                            ]
                            
                            let documentRef = dataBase.collection(Constants.Database.User.userPath).document(userId).collection(Constants.Database.Project.projectPath).document(projectID)
                            
                            //Save project and downloadUrl in database
                            documentRef.setData(documentData)
                            { (error) in
                                if error != nil {
                                    completion(UnsinkableError.databaseCantStoreProject)
                                    return
                                }
                                //Succeed
                                completion(nil)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Firestore is use to store task at taskRef that is the path matching database
    func registerUserTask(_ tasks: [Task?]?,_ project: Project?, completion: @escaping (UnsinkableError?) -> Void) {
        
        let database = Firestore.firestore()
        guard let tasks = tasks else {return}
        guard let userID = project?.ownerUserId else {return}
        guard let projectID = project?.projectID else {return}
        
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
                Constants.Database.Task.title : taskTitle,
                Constants.Database.Task.projectID : projectID,
                Constants.Database.Task.id : taskID,
                Constants.Database.Task.priority : task.priority ?? false,
                Constants.Database.Task.deadLine :  timeStamp ?? "",
                Constants.Database.Task.commentary : task.commentary ?? "",
                Constants.Database.Task.location : task.location ?? "",
                Constants.Database.Task.isValidate: task.isValidate ?? false
            ]
            let documentRef = database.collection(Constants.Database.User.userPath).document(userID).collection(Constants.Database.Project.projectPath).document(projectID).collection(Constants.Database.Task.taskPath).document(taskID)
            
            documentRef.setData(documentData) { error in
                if error != nil {
                    completion(UnsinkableError.databaseCantStoreTask)
                    return
                }
                completion(nil)
                return
            }
        }
    }
    
    //User cloud function to delete files recursivly, databaseRef is the place of the user in database, Storage is used to delete coverPicture in database
    func deleteAllUserRef(_ user: CustomResponse?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let user = user, let userId = user.user.userId else {return}
        guard let token = Keys.value(for: Constants.Token.cloudToken) else {
            return
        }
        let database = Firestore.firestore()
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Users/\(userId)/")
        let databaseRef = database.collection(Constants.Database.User.userPath).document(userId)
        let deleteDatabaseFn = functions.httpsCallable(Constants.CloudFunction.delete)
        let data: [String: Any] = [
            Constants.CloudFunction.path: databaseRef.path,
            Constants.CloudFunction.token: token
        ]
        
        //Delete userRef in storage
        storageRef.listAll { storageList, error in
            if error != nil {
                return completion(UnsinkableError.storageCantListItems)
            } else {
                
                if storageList.items.count > 0 {
                    let _ = storageList.items.map { item in
                        item.delete { error in
                            if error != nil {
                                return completion(UnsinkableError.storageCantDeleteItems)
                            } else {
                                //Delete userRef in database
                                deleteDatabaseFn.call(data) { (result, error)  in
                                    if let error = error as NSError? {
                                        if error.domain == FunctionsErrorDomain {
                                            let code = FunctionsErrorCode(rawValue: error.code)
                                            let message = error.localizedDescription
                                            let details = error.userInfo[FunctionsErrorDetailsKey]
                                            print("code: \(String(describing: code)) /n message: \(message) /n details: \(details ?? "")")
                                        }
                                        completion(UnsinkableError.databaseCantDeleteUser)
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
                                print("code \(String(describing: code)), message \(message), details \(details ?? "")")
                            }
                            completion(UnsinkableError.databaseCantDeleteUser)
                        } else {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    //Cloud function is used to recursivly delete files, project ref match with database struc to delete the right file
    func deleteUserProject(_ project: Project?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let project = project else {return}
        guard let projectID = project.projectID else {return}
        guard let userId = project.ownerUserId else {return}
        guard let token = Keys.value(for: Constants.Token.cloudToken) else {
            return 
        }
        
        let database = Firestore.firestore()
        let projectRef = database.collection(Constants.Database.User.userPath).document(userId).collection(Constants.Database.Project.projectPath).document(projectID)
        let deleteFn = functions.httpsCallable(Constants.CloudFunction.delete)
        let data: [String: Any] = [
            Constants.CloudFunction.path: projectRef.path,
            Constants.CloudFunction.token: token
        ]
        
        deleteFn.call(data) { (result, error)  in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("code \(String(describing: code)), message \(message),details \(details ?? "")")
                }
                completion(UnsinkableError.databaseCantDeleteProject)
            } else {
                guard let projectId = project.projectID else {return}
                let storage = Storage.storage()
                let storageRef = storage.reference().child("Users/\(userId)/\(projectId).jpeg")
                storageRef.delete { error in
                    if error != nil {
                        guard let error = error else {
                            completion(UnsinkableError.unknowError)
                            return
                        }
                        completion(self.convertStorageErrorToUnsinkableError(error))
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    //Cloud function is used to recursivly delete files, task ref match with database struc to delete the right file
    func deleteUserTask(_ project: Project?,_ task: Task?, completion: @escaping (UnsinkableError?) -> Void) {
        guard let project = project, let task = task else {return}
        guard let projectID = project.projectID else {return}
        guard let userId = project.ownerUserId else {return}
        guard let taskId = task.taskID else {return}
        guard let token = Keys.value(for: Constants.Token.cloudToken) else {
            return
        }
        
        let database = Firestore.firestore()
        let projectRef = database.collection(Constants.Database.User.userPath).document(userId).collection(Constants.Database.Project.projectPath).document(projectID).collection(Constants.Database.Task.taskPath).document(taskId)
        let deleteFn = functions.httpsCallable(Constants.CloudFunction.delete)
        let data: [String: Any] = [
            Constants.CloudFunction.path: projectRef.path,
            Constants.CloudFunction.token: token
        ]
        deleteFn.call(data) { (result, error)  in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("code \(String(describing: code)),message \(message),details \(details ?? "")")
                }
                completion(UnsinkableError.databaseCantDeleteTask)
            } else {
                completion(nil)
            }
        }
    }
    
    //Convert error from api Call to CustomError 
    private func convertStorageErrorToUnsinkableError(_ error: Error) -> UnsinkableError {
        guard let error = error as NSError? else {
            return UnsinkableError.unknowError
        }
        guard let errorCode = StorageErrorCode(rawValue: error.code) else {
            return UnsinkableError.unknowError}
        
        return self.handleStorageError(errorCode)
    }
}
