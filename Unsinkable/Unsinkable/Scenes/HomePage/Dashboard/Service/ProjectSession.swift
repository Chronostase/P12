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
    
    func registerUserProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (CustomResponse?, Error?) -> Void) {
        guard let userId = userData?.user.userId else {
            return
        }
        guard let project = project else { return }
        guard let title = project.title else { return }
        guard let description = project.description else { return }
        guard let projectID = project.projectID else { return }
        guard let isPersonal = project.isPersonal else {return}
        
        
        let dataBase = Firestore.firestore()
        let imageID = UUID().uuid
        let storageRef = Storage.storage().reference().child("ProjectsImages/\(imageID)")
        #warning("Use image Data here to put it in storage to get metadata/downloadURl")
        #warning("Manage the fact that user can change several time image so delete older")
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
    
//    func deleteUserProject(_ project: Project?, completion: @escaping (Error?) -> Void) {
//        guard let project = project else {return}
//        guard let projectTitle = project.title else {return}
//        guard let userId = project.ownerUserId else {return}
//        guard let taskList = project.taskList else {return}
//        let database = Firestore.firestore()
//        let projectRef = database.collection("Users").document(userId).collection("Projects").document(projectTitle)
//
//        if taskList.count > 0 {
//            for task in taskList {
//                guard let taskTitle = task?.title else {return}
//                let taskRef = projectRef.collection("Tasks").document(taskTitle)
//                taskRef.delete() { error in
//                    if error != nil {
//                        completion(error)
//                    } else {
//                        completion(error)
//                    }
//                }
//            }
//
//        } else {
//            projectRef.delete() { error in
//                if error != nil {
//                    completion(error)
//                } else {
//                    //Succeed
//                    completion(nil)
//                }
//
//            }
//        }
//    }
    
    func deleteUserProject(_ project: Project?, completion: @escaping (Error?) -> Void) {
        guard let project = project else {return}
        guard let projectTitle = project.title else {return}
        guard let userId = project.ownerUserId else {return}
        
        let database = Firestore.firestore()
        let projectRef = database.collection("Users").document(userId).collection("Projects").document(projectTitle)
        let deleteFn = functions.httpsCallable("recursiveDelete")
        deleteFn.call(projectRef.path) { (result, error)  in
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
