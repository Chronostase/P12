//
//  AuthenticationSession.swift
//  Unsinkable
//
//  Created by Thomas on 25/02/2021.
//

import Foundation
import Firebase

class AuthenticationSession {
    
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
            completion(customUser,error)
        }
    }
    
    func addUserToDataBase(customResponse: CustomResponse?,_ firstName: String, _ name: String, _ email: String, _ password: String, completion: @escaping (CustomResponse?, Error?) -> Void) {
        guard let userId = customResponse?.user.userId else { return }
        let dataBase = Firestore.firestore()
        let documentRef = dataBase.collection("Users").document(userId)
        documentRef.setData(["first_name" : firstName,"name": name,"email" : email, "uid": userId])
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
        let documentRef = database.collection("Users").document("\(data.uid)")
        documentRef.getDocument { (documentSnapshot, error) in
            if error != nil {
                completion(nil, error)
            } else {
                if let document = documentSnapshot, document.exists {
                    guard let data = document.data() else {
                        return
                    }
                    
                    let firstname = data["first_name"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
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
        let documentRef = dataBase.collection("Users").document(userId).collection("Projects")
        documentRef.getDocuments() { (querySnapshot, error) in
            if error != nil {
                guard let error = error else { return }
                completion(nil, error)
            } else {
                guard let queryArray = querySnapshot?.documents else { return }
                
//                #error("ENTER FETCH PROJECT DATA ")
                for document in queryArray {
                    print(queryArray.count)
                    projectIndex += 1
                    print("Index \(projectIndex)")
                    let data = document.data()
                    let projectTitle = data["Title"] as? String ?? ""
                    let projectID = data["projectId"] as? String ?? ""
                    let projectDescription = data["Description"] as? String ?? ""
                    let ownerUserId = data["ownerUserId"] as? String ?? ""
                    let isPersonal = data["isPersonal"] as? Bool
                    let downloadUrl = data["downloadUrl"] as? String ?? ""
                    let tasksRef = dataBase.collection("Users").document(userId).collection("Projects").document(projectTitle).collection("Tasks")
                    tasksRef.getDocuments() { (querys, error) in
                        if error != nil {
                            guard let error = error else {return}
                            completion(nil, error)
                        } else {
                            guard let taskQueryArray = querys?.documents else {return}
                            for document in taskQueryArray {
                                let data = document.data()
                                let taskTitle = data["title"] as? String ?? ""
                                let projectID = data["projectID"] as? String ?? ""
                                let taskID = data["taskID"] as? String ?? ""
                                let taskPriority = data["taskPriority"] as? Bool ?? nil
                                let taskDeadLine = data["taskDeadLine"] as? String ?? ""
                                let taskCommentary = data["taskCommentary"] as? String ?? ""
                                let task = Task(title: taskTitle, projectID: projectID, taskID: taskID, priority: taskPriority, deadLine: taskDeadLine, commentary: taskCommentary)
                                taskList.append(task)
                                print("TaskListCountFetch \(taskList.count)")
                            }
                        }
                        let project = Project(title: projectTitle, projectID: projectID ,description: projectDescription, ownerUserId: ownerUserId, isPersonal: isPersonal, downloadUrl: downloadUrl, taskList: taskList)
                        projectList.append(project)
                        taskList.removeAll()
                        print(taskList.count)
                        // If projectList.count == queryArray.count
                        if projectList.count == queryArray.count{
                            completion(projectList, nil)
                        }
                    }
                }
            }
        }
    }
    
    func fetchTasks(_ userId: String, _ title: String, completion: @escaping ([Task?]?, Error?) -> Void) {
        let database = Firestore.firestore()
        let documentRef = database.collection("Users").document(userId).collection("Projects").document(title).collection("Tasks")
        documentRef.getDocuments() { (querySnapshot, error) in
            if error != nil {
                guard let error = error else {return}
                completion(nil, error)
            } else {
                var taskList = [Task?]()
                guard let query = querySnapshot else {return}
                for document in query.documents {
                    let data = document.data()
                    let taskTitle = data["title"] as? String ?? ""
                    let projectID = data["projectID"] as? String ?? ""
                    let taskID = data["taskID"] as? String ?? ""
                    let taskPriority = data["taskPriority"] as? Bool ?? nil
                    let taskDeadLine = data["taskDeadLine"] as? String ?? ""
                    let taskCommentary = data["taskCommentary"] as? String ?? ""
                    let task = Task(title: taskTitle, projectID: projectID, taskID: taskID, priority: taskPriority, deadLine: taskDeadLine, commentary: taskCommentary)
                    taskList.append(task)
                }
                completion(taskList, nil)
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
