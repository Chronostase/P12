//
//  ProjectSession.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation
import Firebase
import FirebaseStorage

class ProjectSession {
  
    
    func registerUserProject(_ project: Project?,_ userData: CustomResponse?,_ coverPicture: Data?, completion: @escaping (CustomResponse?, Error?) -> Void) {
        guard let userId = userData?.user.userId else {
            return
        }
        guard var project = project else { return }
        guard let title = project.title else { return }
        guard let description = project.description else { return }
        guard let projectID = project.projectID else { return }
        guard let isPersonal = project.isPersonal else {return}
        
        
        let dataBase = Firestore.firestore()
        let imageID = UUID().uuid
        let storageRef = Storage.storage().reference().child("ProjectsImages/\(imageID)")
        #warning("Use image Data here to put it in storage to get metadata/downloadURl")
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
            let documentData: [String: Any] = [
                "title" : taskTitle,
                "projectID" : projectID,
                "taskID" : taskID,
                "taskPriority" : task.priority ?? false,
                "taskDeadLine" : task.deadLine ?? "",
                "taskCommentary" : task.commentary ?? ""
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
}
