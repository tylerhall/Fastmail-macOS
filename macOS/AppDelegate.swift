//
//  AppDelegate.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa
import Foundation
import AppKit

func valueIsNonEmptyString(key: String, value: Any?) -> Bool {
    if let stringValue = value as? String {
        return stringValue.isEmpty == false
    }
    return false
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, DJLURLHandlerDelegate {
    
    var mailTo: [String: String]?;
    
    lazy var prefsWindowController: PrefsWindowController = { PrefsWindowController(windowNibName: String(describing: PrefsWindowController.self)) }()

    override init(){
        super.init()
        registerMailToHandler()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        registerDefaults()

        if createAccountWindowControllers() == 0 {
            showPrefs(nil)
        } else {
            showAllAccountWindows()
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        for a in Account.accounts {
            if a.windowController.window?.isVisible ?? false {
                return true
            }
        }
        showAppropriateAccountWindows()
        return true
    }

    func registerDefaults() {
        var defaults: [String: Any] = [:]

        if let defaultsPath = Bundle.main.path(forResource: "Defaults", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: defaultsPath) as? [String: Any] {
                defaults.merge(dict: dict)
            }
        }

        let computedDefaults: [String: Any] = [:]
        defaults.merge(dict: computedDefaults)

        UserDefaults.standard.register(defaults: defaults)
    }

    func registerMailToHandler() {
        if let djlUrlHandler = DJLURLHandler.sharedManager(){
            djlUrlHandler.delegate = self;
            djlUrlHandler.isReady = true;
        }
    }
    
    func createAccountWindowControllers() -> Int {
        for account in Account.accounts {
            if let windowsMenu = NSApp.windowsMenu, let menuItem = account.windowMenuItem {
                windowsMenu.removeItem(menuItem)
            }
            account.windowController.close()
        }
        Account.accounts.removeAll()
        
        if let windowsMenu = NSApp.windowsMenu {
            let item = NSMenuItem.separator()
            windowsMenu.insertItem(item, at: windowsMenu.items.count)
        }
        
        
        var index = 1
        let config = (Constants.accountsConfigText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let lines = config.components(separatedBy: "\n")
        for line in lines {
            let tokens = line.components(separatedBy: " ")
            if let url = URL(string: tokens[0]), let host = url.host, host.hasSuffix("fastmail.com") {
                var badgeNumber = 1
                if tokens.indices.contains(1) {
                    badgeNumber = Int(tokens[1]) ?? 1
                }

                var reopenOnAppActivate = true
                if tokens.indices.contains(2) {
                    reopenOnAppActivate = (tokens[2] == "1")
                }

                let account = Account(url, badgeNumber: badgeNumber, reopenOnAppActivate: reopenOnAppActivate)
                
                if let windowsMenu = NSApp.windowsMenu {
                    let item = NSMenuItem(title: "Fastmail", action: #selector(dumbShowWindow(_:)), keyEquivalent: "\(index)")
                    windowsMenu.insertItem(item, at: windowsMenu.items.count)
                    account.windowMenuItem = item
                }
                
                account.accountLoginCallback = {
                    if (self.mailTo != nil){
                        self.composeMessageWithFirstLoggedInAccount()
                    }
                }

                Account.accounts.append(account)
                
                index += 1
            }
        }

        return Account.accounts.count
    }
    
    func showAllAccountWindows() {
        for a in Account.accounts.reversed() {
            a.showWindow()
        }
    }

    func showAppropriateAccountWindows() {
        for a in Account.accounts.reversed() where a.reopenOnAppActivate {
            a.showWindow()
        }
    }
    
    func composeMessageWithFirstLoggedInAccount(){
        if let mailTo = self.mailTo {
            for a in Account.accounts {
                if (a.isLoggedIn){
                    a.mailTo(mailTo)
                    self.mailTo = nil
                    break
                }
            }
        }
    }
    
    @objc func dumbShowWindow(_ sender: AnyObject?) {
        if let menuItem = sender as? NSMenuItem {
            for a in Account.accounts {
                if a.windowMenuItem == menuItem {
                    a.showWindow()
                    break
                }
            }
        }
    }
    
    // MARK: DJLURLHandler delegate
    
    func djlurlHandler(_ handler: DJLURLHandler!, composeMessageWithTo to: String, cc: String, bcc: String, subject: String, body: String) {
        self.mailTo = ["to":to, "cc":cc, "bcc":bcc, "subject":subject, "body":body].filter(valueIsNonEmptyString)
        self.composeMessageWithFirstLoggedInAccount()
    }
    
    func djlurlHandler(_ handler: DJLURLHandler!, composeMessageWithTo to: String, cc: String, bcc: String, subject: String, htmlBody: String) {
        //TODO: is passing HTML to "body" kosher?
        self.mailTo = ["to":to, "cc":cc, "bcc":bcc, "subject":subject, "body":htmlBody].filter(valueIsNonEmptyString)
        self.composeMessageWithFirstLoggedInAccount()
    }
    
}

extension AppDelegate {

    @IBAction func showPrefs(_ sender: AnyObject?) {
        prefsWindowController.showWindow(sender)
    }
}
