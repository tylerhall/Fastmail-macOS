//
//  HiddenWebView.swift
//  Fastmail
//
//  Created by Tyler Hall on 3/19/20.
//  Copyright © 2020 Your Company. All rights reserved.
//

import Cocoa
import WebKit

class HiddenWebView {
    
    weak var account: Account!
    var webView = FMWebView(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
    var inboxTimer: Timer?

    func startMonitoring() {
        inboxTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.getInboxCount()
            self.getUnreadEmails()
        })
    }

    func getInboxCount() {
        let script = try! String(contentsOf: Bundle.main.url(forResource: "getInboxCount", withExtension: "js")!)
        DispatchQueue.main.async {
            self.webView.evaluateJavaScript(script) { (val, error) in
                if error == nil {
                    self.account.inboxCount = Int((val as? String) ?? "0") ?? 0
                    Notifications.updateDockBadge()
                }
            }
        }
    }

    func getUnreadEmails() {
        let script = try! String(contentsOf: Bundle.main.url(forResource: "getUnreadEmails", withExtension: "js")!)
        DispatchQueue.main.async {
            self.webView.evaluateJavaScript(script) { (val, error) in
                if error == nil, let emails = val as? [[String: String]] {
                    for email in emails {
                        if let href = email["itemHREF"], let from = email["itemFrom"], let subject = email["itemSubject"] {
                            if !EmailMemory.hasBeenSeen(href) {
                                EmailMemory.remember(href)
                                Notifications.newMail(from, subject: subject)
                            }
                        }
                    }
                }
            }
        }
    }
}
