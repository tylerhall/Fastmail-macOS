//
//  Account.swift
//  Fastmail
//
//  Created by Tyler Hall on 3/23/20.
//  Copyright © 2020 Your Company. All rights reserved.
//

import Cocoa
import WebKit

class Account {
    
    static var accounts = [Account]()
    
    var url: URL
    var name: String
    var badgeNumber: Int
    var reopenOnAppActivate: Bool

    var windowController: AccountWindowController
    var hiddenWebView: HiddenWebView

    var windowMenuItem: NSMenuItem?
    var accountLoginCallback: (() -> ())?
    var isLoggedIn: Bool;

    var inboxCount = 0 {
        didSet {
            if inboxCount == 0 {
                windowController.window?.title = name
            } else {
                windowController.window?.title = name + " (\(inboxCount))"
            }

            windowMenuItem?.title = name
        }
    }

    init(_ url: URL, badgeNumber: Int, reopenOnAppActivate: Bool) {
        self.url = url
        self.name = "Fastmail"
        self.badgeNumber = badgeNumber
        self.reopenOnAppActivate = reopenOnAppActivate

        self.hiddenWebView = HiddenWebView()
        
        self.windowController = AccountWindowController(windowNibName: String(describing: AccountWindowController.self))
        self.isLoggedIn = false

        self.hiddenWebView.account = self
        self.windowController.account = self

        self.windowController.windowDidLoadCallback = {
            self.loadHomePage()
            self.checkForLogin()
        }
    }

    func showWindow() {
        windowController.showWindow(nil)
    }
        
    func mailTo(_ mailTo: [String: String]){
        var mailToUrl = self.url
        mailToUrl.appendPathComponent("compose")
        let finalMailToUrl = mailToUrl.appendingQueryItems(mailTo)
        windowController.webView.load(URLRequest(url: finalMailToUrl))
    }

}

extension Account {

    func loadHomePage() {
        windowController.webView.load(URLRequest(url: url))
    }
    
    func checkForLogin() {
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let script = try! String(contentsOf: Bundle.main.url(forResource: "checkForLogin", withExtension: "js")!)
            DispatchQueue.main.async {
                self.windowController.webView.evaluateJavaScript(script) { (val, error) in
                    if error == nil {
                        timer.invalidate()
                        self.setupHiddenWebView()
                        self.name = (val as? String) ?? "Fastmail"
                        self.isLoggedIn = true
                        self.accountLoginCallback?()
                    }
                }
            }
        }
    }
    
    func setupHiddenWebView() {
        hiddenWebView.webView.load(URLRequest(url: url))
        hiddenWebView.startMonitoring()
    }
}
