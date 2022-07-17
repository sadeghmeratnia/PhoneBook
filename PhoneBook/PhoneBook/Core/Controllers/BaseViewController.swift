//
//  BaseViewController.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import UIKit

class BaseViewController: UIViewController {
  var coordinator: CoordinatorDelegate?
}
extension BaseViewController: Storyboarded {}
