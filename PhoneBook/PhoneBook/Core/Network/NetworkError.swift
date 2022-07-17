//
//  NetworkError.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import Foundation

enum NetworkError: Error, Equatable {
  case parsing
  case urlParsing
  case network
  case invalidResponse
  case authorization
  case badRequest(message: String? = nil)
}

extension NetworkError {
  public var errorDescription: String? {
    switch self {
      case .badRequest(let message):
        return message ?? "Bad Request"
      case .authorization:
        return "Authorization Failed"
      default:
        return "Something Wrong!"
    }
  }
}
