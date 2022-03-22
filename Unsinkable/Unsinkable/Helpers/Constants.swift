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
        
        enum Title {
            static let unknowError = "Unknow error"
            static let operationNotAllowed = "Operation not allowed"
            static let recentLogin = "Recent login required"
            
            static let invalidEmail = "Invalid email"
            static let loginWrongPassword = "Wrong password"
            static let loginUserDisabled = "User disabled"
            
            static let registerEmailAlreadyUse = "Already used email"
            static let registerWeakPassword = "Weak password"
            
            static let invalidCredential = "Reauthenticate failed"
            static let userMisMatch = "User misMatch"
            
            static let setTitle = "Title error"
            
            static let databaseCantStoreUser = "Can't store user"
            static let databaseCantStoreProject = "Can't save project"
            static let databaseCantDeleteUser = "Error while user deletion"
            static let databaseCantUpdate = "Can't update Data"
            static let databaseCantFetchData = "Can't fetch data"
            static let databaseCantFetchTask = "Can't fetch your tasks"
            static let databaseCantStoreTask = "Can't save your tasks"
            static let databaseCantAccessToProject = "Can't have access to this project"
            static let databaseCantDeleteProject = "Can't delete this project"
            static let databaseCantUpdateTask = "Can't update your task"
            static let databaseCantDeleteTask = "Can't delete task"
            static let databaseCantFetchUserData = "Can't fetch data"
            
            static let storageCantListItems = "Can't access to your files"
            static let storageCantDeleteItems = "Error while deletion"
            static let storageCantSaveImage = "Can't save your cover picture"
            
            static let storageObjectNotFound = "None object found"
            static let storageBucketNotFound = "UnknowError"
            static let storageProjectNotFound = "UnknowError"
            static let storageQuotaExceeded = "UnknowError"
            static let storageUnauthenticate = "Not authenticate user"
            static let storageUnauthorized = "Unauthorized operation"
            static let storageRetryLimiteExceeded = "Time limite exceeded"
            static let nonMatchingCheckSum = "Unknow error"
            static let canceled = "You cancel the operation"
            static let downloadSizeExceeded = "File size exceeded"
            
            static let imageDownloadUrl = "No metadata access"
        }
        
        enum Body {
            
            //Generic
            static let unknowError = "Unknow error occured please retry"
            static let recentLogin = "You need a recent login to proceed this operation"
            static let operationNotAllowed = ""
            
            //Login
            static let emailError = "Email is not correct."
            static let emailAlreadyUse = "Email is already in use by another account" 
            static let passwordError = "Please make sure your password is at least 8 characters, contains a special character and a number."
            static let fillField = "Please fill in all fields."
            static let invalidFields = "some fields are invalid please check them."
            static let cantFormat = "We can't format fields please retry"
            static let incorrectLog = "Incorrect log please retry."
            static let incorrectPassword = "Incorrect password"
            static let weakPassword = "Your password is too weak."
            static let userDisable = "Your user account is disable"
            static let invalidCredential = "Invalid data connection"
            static let userMisMatch = "You are not the actual user of this account"
            static let notAllowOperation = "You account is no more activated."
            
            //Project Creation
            static let setTitle = "You need to have at least a project title"
            
            //Database
            static let databaseCantStoreUser = "We can't store user for unknow reaseon please retry"
            static let databaseCantStoreProject = "We can't save your project please retry"
            static let databaseCantUpdate = "We can't update data for unknow reason please retry"
            static let databaseCantDeleteUser = "We can't delete user reference please retry"
            static let databaseCantStoreTask = "Try to add it again when you consult your project"
            static let databaseCantAccessToProject = "Unknow reason please retry"
            static let databaseCantDeleteProject = "Unknow reason please retry"
            static let databaseCantUpdateTask = "Unknow reason please retry"
            static let databaseCantDeleteTask = "Unknow reason please retry"
            
            static let databaseCantFetchUserData = "Please make sure to have internet connection and retry"
            static let databaseCantFetchData = "Please make sure to have internet connection and relaunch Unsinkable"
            
            //Storage
            static let storageCantListItems = "Can't access to your stored cover pictures please retry"
            static let storageCantDeleteItems = "Can't delete your stored pictures please retry"
            static let storageCantSaveImage = "We can't save your cover picure please retry"
            
            static let storageObjectNotFound = "None object found or existing"
            static let storageBucketNotFound = "Please retry"
            static let storageProjectNotFound = "Please retry"
            static let storageQuotaExceeded = "Please retry"
            static let storageUnauthenticate = "You are not authenticated, please reconnect your account"
            static let storageUnauthorized = "You don't have the permission to proceed this operation"
            static let storageRetryLimiteExceeded = "Operation was canceled because it take too much time please retry"
            static let nonMatchingCheckSum = "Please retry"
            static let canceled = ""
            static let downloadSizeExceeded = "Please select smaller file"
            //Image
            static let imageDownloadUrl = "We can't access to image metada"
        }
        
        enum ProjectCreation {
            static let setProjectTitle = "You need to have at least a project title"
            static let setTaskTitle = "You need at least a title"
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
        static let addTaskHolder = "+ Add Task"
        static let descriptionPlaceHolder = "Description..."
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
