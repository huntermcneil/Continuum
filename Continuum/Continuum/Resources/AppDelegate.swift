//
//  AppDelegate.swift
//  Continuum
//
//  Created by Hunter McNeil on 6/30/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkAccountStatus { (success) in
            if success {
                print("Successfully retrieved a logged in user")
            } else {
                print("Failed to retrieve a logged in user")
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func checkAccountStatus(completion: @escaping (Bool) -> Void) {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("There was an error - \(error) - \(error.localizedDescription)")
                return completion(false)
            }
            DispatchQueue.main.async {
                
                let tabBarController = self.window?.rootViewController
                let errorText = "Please sign into your iCloud account"
                
                switch status {
                case .couldNotDetermine:
                    tabBarController?.presentSimpleAlertWith(title: errorText, message: "Couldn't find your iCloud account")
                    return completion(false)
                case .available:
                    print("iCloud account found")
                    return completion(true)
                case .restricted:
                    tabBarController?.presentSimpleAlertWith(title: errorText, message: "Your iCloud account has been restricted")
                    return completion(false)
                case .noAccount:
                    tabBarController?.presentSimpleAlertWith(title: errorText, message: "Could not find an existing iCloud account")
                    return completion(false)
                @unknown default:
                    return completion(false)
                }
            }
        }
    }
}
