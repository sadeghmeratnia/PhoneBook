//
//  ContactModel.swift
//  PhoneBook
//
//  Created by Sadegh on 7/16/22.
//

import Foundation

struct ContactModel: Codable {
    let _id: String?
    let firstName: String?
    let lastName: String?
    let phone: String?
    let email: String?
    let notes: String?
    let images: [String?]?
}
