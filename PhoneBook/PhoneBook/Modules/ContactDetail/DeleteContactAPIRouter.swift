//
//  DeleteContactAPIRouter.swift
//  PhoneBook
//
//  Created by Sadegh on 7/17/22.
//

import Foundation

struct DeleteContactAPIRouter: APIRouter {
    typealias ResponseType = DeleteContactModel
    static var method: HTTPMethod = .delete
    static var path: String = "contacts"
    var requestBody: Encodable?
}
