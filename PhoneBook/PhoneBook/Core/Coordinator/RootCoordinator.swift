//
//  RootCoordinator.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import UIKit

class RootCoordinator: CoordinatorDelegate {
    var navigationController: UINavigationController
    var window: UIWindow?
    
    init(window: UIWindow) {
        self.navigationController = NavigationController()
        self.window = window
    }
    
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let coordinator = ContactsListCoordinator(self.navigationController)
        coordinator.start()
    }
}
