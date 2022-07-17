//
//  CoordinatorDelegate.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
