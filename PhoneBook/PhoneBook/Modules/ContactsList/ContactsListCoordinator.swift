//
//  ContactsListCoordinator.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import UIKit

class ContactsListCoordinator: CoordinatorDelegate {
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ContactsListViewController.instantiate()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func coordinateToDetail(contact: ContactModel? = nil) {
        let detailCoordinator = ContactDetailCoordinator(self.navigationController, contact: contact)
        detailCoordinator.start()
    }
}
