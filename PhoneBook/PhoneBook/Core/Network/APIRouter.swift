//
//  APIRouter.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import Foundation

public protocol BasicType: Codable, Hashable, RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible {}

public protocol APIRouter {
    static var method: HTTPMethod { get }
    static var path: String { get }
    static var requestType: IBRequestType { get }
    static var retriable: Bool { get }

    var requestBody: Encodable? { get }
    var queryParams: [String: String]? { get }

    associatedtype ResponseType: Codable
}

extension APIRouter {
    public static var method: HTTPMethod {
        return .post
    }

    public static var requestType: IBRequestType {
        switch method {
        case .post, .patch:
            return .jsonBody
        case .get:
            return .urlQuery
        default:
            return .httpHeader
        }
    }

    public static var retriable: Bool {
        true
    }

    public var queryParams: [String: String]? {
        nil
    }

    public var requestBody: Encodable? {
        nil
    }
}

extension Encodable {
    func toJSON() -> Data? { try? JSONEncoder().encode(self) }
}

public struct HTTPMethod: BasicType {
    public let rawValue: String
    public var description: String { return rawValue }
    public var debugDescription: String {
        return "HTTP Method: \(rawValue)"
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    init(_ description: String) {
        self.rawValue = description.uppercased()
    }

    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let patch = HTTPMethod(rawValue: "PATCH")
}

public enum IBRequestType {
    case httpHeader
    case jsonBody
    case multipartFromData
    case urlQuery
}
