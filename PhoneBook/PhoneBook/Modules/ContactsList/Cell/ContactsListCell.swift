//
//  ContactsListCell.swift
//  PhoneBook
//
//  Created by Sadegh on 7/16/22.
//

import Foundation
import UIKit
import Kingfisher

class ContactsListCell: UITableViewCell {
    @IBOutlet private weak var contactImageView: UIImageView!
    @IBOutlet private weak var contactName: UILabel!
    @IBOutlet private weak var contactPhone: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(contact: ContactModel) {
        self.contactName.font = UIFont.sansMedium(16)
        self.contactPhone.font = UIFont.sans(14)
        self.contactName.textColor = .black
        self.contactPhone.textColor = .black
        self.contactName.text = (contact.firstName ?? "") + " " + (contact.lastName ?? "")
        self.contactPhone.text = contact.phone
        
        let placeholder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        self.contactImageView.setImage(url: contact.images?.first ?? "", placeholder: placeholder ?? UIImage())
    }
}
