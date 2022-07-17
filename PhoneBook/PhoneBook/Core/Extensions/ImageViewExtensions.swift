//
//  ImageViewExtensions.swift
//  PhoneBook
//
//  Created by Sadegh on 7/16/22.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(url: String?, placeholder: UIImage) {
        self.kf.setImage(with: URL(string: url ?? "") ?? URL(fileURLWithPath: ""),
                         placeholder: placeholder,
                         options: nil, completionHandler: nil)
    }
}
