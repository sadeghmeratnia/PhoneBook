//
//  ViewControllerExtension.swift
//  PhoneBook
//
//  Created by Sadegh on 7/16/22.
//

import UIKit

protocol Storyboarded {
    static func instantiate(_ storyboardId: String?) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(_ storyboardId: String? = nil) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: className, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        // Force cast can help cache the storyboards errors easily
        // swiftlint:disable force_cast
        return storyboard.instantiateViewController(withIdentifier: storyboardId ?? className) as! Self
    }
}
