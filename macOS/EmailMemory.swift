//
//  EmailMemory.swift
//  Fastmail
//
//  Created by Tyler Hall on 3/23/20.
//  Copyright © 2020 Your Company. All rights reserved.
//

import Foundation

class EmailMemory {
    
    static let defaults = UserDefaults.init(suiteName: "io.tyler.Fastmail.EmailMemory")
    static var emailIDs = Set<String>()
    
    static func remember(_ emailID: String) {
        emailIDs.insert(emailID)
        
        if var emails = EmailMemory.defaults?.value(forKey: "emails") as? [String: Date] {
            emails[emailID] = Date()
            EmailMemory.defaults?.setValue(emails, forKey: "emails")
        } else {
            var emails = [String: Date]()
            emails[emailID] = Date()
            EmailMemory.defaults?.setValue(emails, forKey: "emails")
        }
    }
    
    static func hasBeenSeen(_ emailID: String) -> Bool {
        return emailIDs.contains(emailID)
    }
}
