//
//  Fonts.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import UIKit

extension UIFont {
    static func sansBold(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    static func sansMedium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    static func sans(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
}
