//
//  StringExtensions.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import Foundation

extension String {
    var localize: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localizedWithArgs(_ args: [CVarArg]) -> String {
        return String(format: self.localize, arguments: args)
    }
}
