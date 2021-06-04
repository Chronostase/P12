//
//  AppDelegate.swift
//  Unsinkable
//
//  Created by Thomas on 06/01/2021.
//

import UIKit
import Firebase
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //    var appCoordinator: AppCoordinator?
    //To make tabbar work need to delete coordinator, and pass tabbar in window.rootVC
    var coordinator: CoordinatorManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        // Override point for customization after application launch.
        let navController = UINavigationController()
        coordinator = CoordinatorManager(navigationController: navController)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        //        TabBarViewController()
        
        
        window?.makeKeyAndVisible()
        ///////////////////////////////////////////////////////////////////////
        // Test from Scratch
        //////////////////////////////////////////////////////////////////////
        //        let navigationController: UINavigationController = .init()
        //
        //        window?.rootViewController = navigationController
        //        window?.makeKeyAndVisible()
        //
        //        appCoordinator = AppCoordinator.init(navigationController)
        //        appCoordinator?.start()
        
        return true
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
    }
    
}


