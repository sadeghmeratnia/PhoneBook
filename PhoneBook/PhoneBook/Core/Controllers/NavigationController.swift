//
//  NavigationController.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupStyle()
    }
    
    func setupStyle() {
//        self.navigationBar.tintColor = UIColor(named: Colors.primary.rawValue)
        self.view.backgroundColor = UIColor(named: Colors.primary.rawValue)
        self.navigationBar.backgroundColor = UIColor(named: Colors.primary.rawValue)
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = false
//        self.navigationBar.barTintColor = UIColor(named: Colors.primary.rawValue)
//
//        let barButtonAttributes = [NSAttributedString.Key.font: UIFont.sansMedium(20)]
//        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: .normal)
    }
}
