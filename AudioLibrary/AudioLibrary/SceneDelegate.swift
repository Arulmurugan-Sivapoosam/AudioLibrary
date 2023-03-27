//
//  SceneDelegate.swift
//  AudioLibrary
//
//  Created by Dhiya on 23/03/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UINavigationController(rootViewController: CommandLine.isUITestingLaunch ? MockSongListController() : SongListController())
    self.window = window
    window.makeKeyAndVisible()
  }
}

private extension CommandLine {
  /// Property returns true if commandline arguments contains UITesting flag.
  static var isUITestingLaunch: Bool {
    arguments.contains("isUITesting")
  }
}
