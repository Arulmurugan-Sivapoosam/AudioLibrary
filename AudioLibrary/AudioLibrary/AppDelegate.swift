//
//  AppDelegate.swift
//  AudioLibrary
//
//  Created by Dhiya on 23/03/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    CoreDataWorker.shared.loadPersistantContainer()
    return true
  }
}
