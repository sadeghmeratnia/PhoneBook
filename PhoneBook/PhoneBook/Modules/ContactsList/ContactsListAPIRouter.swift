//
//  ContactsListAPIRouter.swift
//  PhoneBook
//
//  Created by Sadegh on 7/16/22.
//

import Foundation

struct ContactsListAPIRouter: APIRouter {
    typealias ResponseType = [ContactModel]
    static var method: HTTPMethod = .get
    static var path: String = "contacts"
    var queryParams: [String : String]?
}
