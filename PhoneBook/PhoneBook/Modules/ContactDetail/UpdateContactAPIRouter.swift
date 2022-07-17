//
//  UpdateContactAPIRouter.swift
//  PhoneBook
//
//  Created by Sadegh on 7/17/22.
//

import Foundation

struct UpdateContactAPIRouter: APIRouter {
    typealias ResponseType = ContactModel
    static var method: HTTPMethod = .patch
    static var path: String = "contacts"
    var requestBody: Encodable?
}
