//
//  AddContactAPIRouter.swift
//  PhoneBook
//
//  Created by Sadegh on 7/17/22.
//

import Foundation

struct AddContactAPIRouter: APIRouter {
    typealias ResponseType = ContactModel
    static var method: HTTPMethod = .post
    static var path: String = "contacts"
    var requestBody: Encodable?
}
