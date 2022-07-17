//
//  ContactDetailCoordinator.swift
//  PhoneBook
//
//  Created by Sadegh on 7/16/22.
//

import UIKit

class ContactDetailCoordinator: CoordinatorDelegate {
    var navigationController: UINavigationController
    var contact: ContactModel?
    
    init(_ navigationController: UINavigationController, contact: ContactModel?) {
        self.navigationController = navigationController
        self.contact = contact
    }
    
    func start() {
        let viewController = ContactDetailViewController.instantiate()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func coordinateToContactList(_ newContact: ContactModel) {
        guard let parent = self.navigationController.viewControllers.first as? ContactsListViewController else { return }
        
        var updatedModel = self.updateModel(contactID: newContact._id ?? "")
        updatedModel?.insert(newContact, at: 0)
        parent.viewModel.model.accept(updatedModel ?? [])
        
        navigationController.popToViewController(parent, animated: true)
    }
    
    func popToRootView(_ deletedContactID: String) {
        guard let parent = self.navigationController.viewControllers.first as? ContactsListViewController else { return }
        
        let updatedModel = self.updateModel(contactID: deletedContactID)
        parent.viewModel.model.accept(updatedModel ?? [])
        
        navigationController.popToViewController(parent, animated: true)
    }
    
    private func updateModel(contactID: String) -> [ContactModel]? {
        guard let parent = self.navigationController.viewControllers.first as? ContactsListViewController else { return nil }
        
        var oldData = parent.viewModel.model.value
        
        if oldData.first(where: { $0._id == contactID }) != nil {
            oldData.removeAll(where: { $0._id == contactID })
        }
        return oldData
    }
}
