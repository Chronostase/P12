//
//  Constants.swift
//  Unsinkable
//
//  Created by Thomas on 18/02/2021.
//

import Foundation

enum Constants {
    enum LoginString {
        static let register = "Register"
        static let  longinButton = "Login"
        static let signIn = "Sign in"
        static let or = "or"
        static let appleLogin = "Login with Apple"
        static let emailPlaceHolder = "Email..."
        static let passwordPlaceHolder = "Password..."
        static let firstNamePlaceHolder = "Firstname..."
        static let namePlaceHolder = "Name..."
    }
    
    enum Cell {
        static let projectCell = "ProjectCell"
        static let taskCell = "TaskCell"
    }
    
    enum Database {
        
        enum User {
            static let userPath = "Users"
            static let firstNameField = "first_name"
            static let nameField = "name"
            static let emailField = "email"
            static let uidField = "uid"
        }
        
        enum Project {
            static let projectPath = "Projects"
            static let title = "Title"
            static let id = "projectId"
            static let description = "Description"
            static let ownerID = "ownerUserId"
            static let isPersonal = "isPersonal"
            static let downloadURL = "downloadUrl"
            
        }
        
        enum Task {
            static let taskPath = "Tasks"
            static let title = "title"
            static let projectID = "projectID"
            static let id = "taskID"
            static let priority = "taskPriority"
            static let deadLine = "taskDeadLine"
            static let commentary = "taskCommentary"
            static let location = "location"
            static let isValidate = "isValidate"
        }
    }
    
    enum CloudFunction {
        static let path = "path"
        static let token = "token"
        static let delete = "recursiveDelete"
    }
    
    enum Error {
        
        static let retry = "An error occured please retry"
        enum LoginError {
            static let emailError = "Email is not correct."
            static let passwordError = "Please make sure your password is at least 8 characters, contains a special character and a number."
            static let fillField = "Please fill in all fields."
            static let invalidFields = "some fields are invalid please check them."
            static let cantFormat = "We can't format fields please retry"
            static let incorrectLog = "Incorrect log please retry."
        }
    }
    
    enum Token {
        static let cloudToken = "cloudToken"
    }
    
    enum StoryBoard {
        static let mainLoginPage = "MainLoginPage"
        static let signIn = "SignIn"
        static let register = "Register"
        static let dashBoard = "DashBoard"
        static let notificationCenter = "NotificationCenter"
        static let profil = "Profil"
        static let projectCreation = "ProjectCreation"
        static let projectReading = "ProjectReading"
        static let taskEditor = "TaskEditor"
        static let updateProject = "UpdateProject"
    }
    
    enum Notification {
        static let childEnd = "ChildEnd"
    }
    
    enum Label {
        static let finishedTask = "Finished Task:"
        static let commentaryPlaceHolder = "Commentary..."
        static let locationPlaceHolder = "location..."
    }
    
    enum Button {
        static let deleteUserAccount = "Delete User account"
        static let logout = "Logout"
        static let editProfil = "Edit profil"
        static let saveChange = "Save change"
        static let performChange = "Perform Change"
        static let edit = "Edit"
        static let saveTask = "Save task"
        static let done = "Done"
        static let finish = "Finish"
        static let moreOptions = "More Options"
        static let updateProject = "Update project"
        static let deleteProject = "Delete Project"
        static let cancel = "Cancel"
        static let yes = "Yes"
        static let deleteAccount = "Are you want to delete this account"
        static let deleteMessage = "Are you want to delete this item"
    }
    
    enum Image {
        static let clipBoard = "clipboard"
        static let bell = "bell"
        static let plusCircle = "plus.circle.fill"
        static let ellipsis = "ellipsis"
        static let cover = "cover"
    }
}
