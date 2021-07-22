//
//  ProjectSession.swift
//  Unsinkable
//
//  Created by Thomas on 06/07/2021.
//

import Foundation
import FirebaseFirestore

class ProjectSession {
    
    //    func addProjectToDataBase(userData: CustomResponse?, completion: @escaping (CustomResponse?, Error?) -> Void) {
    //
    //        guard let userId = userData?.user.userId else {
    //            return
    //        }
    //        let dataBase = Firestore.firestore()
    //        dataBase.collection("Users").document("\(userId)").set
    //        // Add user in database collection
    //        //        dataBase.collection("Users").addDocument(data: ["first_name" : firstName,"name": name, "uid": userId])
    //        dataBase.collection("Users").document("\(userId)").setData(["project": Project]) { (error) in
    //            if error != nil {
    //                guard let error = error else { return }
    //                completion(nil,error)
    //            }
    //            completion(customResponse,error)
    //        }
    //
    //    }
    
    func registerUserProject(_ project: Project?,_ userData: CustomResponse? , completion: @escaping (CustomResponse?, Error?) -> Void) {
        guard let userId = userData?.user.userId else {
            return
        }
        guard let project = project else { return }
        guard let title = project.title else { return }
        guard let description = project.description else { return }
        let dataBase = Firestore.firestore()
        let documentData: [String: Any] = [
            "Title": title,
            "Description": description,
            "ownerUserId": userId
        ]
        
        let documentRef = dataBase.collection("Users").document(userId).collection("Projects").document(title)
        
        documentRef.setData(documentData)
        { (error) in
            if error != nil {
                guard let error = error else { return }
                completion(nil,error)
            }
            completion(nil,error)
        }
    }
    
//    func createUserProjectList(_ userData: CustomResponse?, completion: @escaping (CustomResponse?, Error?) -> Void) {
//        guard let userId = userData?.user.userId else {
//            return
//        }
//        let dataBase = Firestore.firestore()
//        // Add user in database collection
//        //        dataBase.collection("Users").addDocument(data: ["first_name" : firstName,"name": name, "uid": userId])
//
//            #warning("Fill with textField")
//        let documentData: [String: Any] = [
//            "Title": userData,
//            "Description": "It GONNA WORK"
//        ]
//        let documentRef = dataBase.collection("Users").document(userId).collection("Project").document("Ranger")
//
//
////        dataBase.collection("Users").document("\(userId)").setData(documentData)
//        documentRef.setData(documentData)
//        { (error) in
//            if error != nil {
//                guard let error = error else { return }
//                completion(nil,error)
//            }
//            completion(nil,error)
//        }
//    }
    
    func fetchTask(_ data: CustomResponse?, completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        guard let userId = data?.user.userId else {
            return
        }
        let dataBase = Firestore.firestore()
        let documentRef = dataBase.collection("Users").document(userId).collection("Project")
            
            documentRef.addSnapshotListener { querySnapshot, error in
            if error != nil {
                guard let error = error else {
                    return
                }
                completion(nil, error)
            }
            guard let documents = querySnapshot?.documents else {
                //no documents
                return
            }
            completion(documents, nil)
            
        }
    }
    
    //    func fetchUserProject(userData: CustomResponse?, completion: @escaping (CustomResponse?, Error?) -> Void) {
    //        let userId = userData?.user.userId
    //    }
}
