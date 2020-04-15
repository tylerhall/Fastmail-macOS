//
//  Constants.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import AppKit

class Constants {

    static var accountsConfigText: String? {
        get {
            return UserDefaults.standard.string(forKey: "accountsConfigText")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accountsConfigText")
        }
    }
}
