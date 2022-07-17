//
//  SceneDelegate.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: RootCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.setupView(scene: scene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    func setupView(scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        coordinator = RootCoordinator(window: window ?? UIWindow())
        coordinator?.start()
    }
}

