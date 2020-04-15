//
//  Notifications.swift
//  Fastmail
//
//  Created by Tyler Hall on 3/19/20.
//  Copyright © 2020 Your Company. All rights reserved.
//

import AppKit

class Notifications {

    static var previousCounts = [Int: Int]()

    static func newMail(_ from: String, subject: String) {
        let sound = NSSound(named: "New Mail")
        sound?.play()

        let accountName = UserDefaults.standard.string(forKey: "AccountName") ?? "Fastmail"

        let notification = NSUserNotification()
        notification.identifier = NSUUID.init().uuidString
        notification.title = "New \(accountName) email from \(from)"
        notification.subtitle = subject
        // notification.informativeText = ""
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    static func updateDockBadge() {
        var counts = [Int: Int]()
        for a in Account.accounts {
            if counts[a.badgeNumber] == nil {
                counts[a.badgeNumber] = a.inboxCount
            } else {
                counts[a.badgeNumber]! += a.inboxCount
            }
        }

        if previousCounts != counts {
            let dockView = DockView()
            dockView.counts = counts
            NSApp.dockTile.contentView = dockView
            NSApp.dockTile.display()
            previousCounts = counts
        }
    }
}

// I'm sorry this is so horribly ugly. I wrote it in a hurry :-(
class DockView: NSView {
    
    var counts = [Int: Int]()

    override func draw(_ dirtyRect: NSRect) {
        let image = NSApp.applicationIconImage
        image?.draw(in: dirtyRect)

        if let count = counts[1], count > 0 {
            let nf = NumberFormatter()
            nf.numberStyle = .none
            if let str = nf.string(from: NSNumber(integerLiteral: count)) {
                let attrs = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: NSColor.white]
                let attrStr = NSAttributedString(string: str, attributes: attrs)
                let attrSize = attrStr.size()
                let possibleSize = attrSize
                let maxedSize = CGSize(width: max(possibleSize.width, bounds.size.width * 0.3), height: max(possibleSize.height, bounds.size.height * 0.3))
                let textSize = CGSize(width: max(maxedSize.width, maxedSize.height), height: maxedSize.height)
                let size = CGSize(width: textSize.width + 16, height: textSize.height)
                let centeredRect = CGRect(x: (bounds.size.width / 2) - (size.width / 2), y: (bounds.size.height / 2) + (size.height / 2), width: size.width, height: size.height).offsetBy(dx: bounds.size.width / 4 + 5, dy: 5)
                let centeredTextRect = CGRect(x: (centeredRect.size.width / 2) + centeredRect.origin.x - (attrSize.width / 2), y: (centeredRect.size.height / 2) + centeredRect.origin.y - (attrSize.height / 2), width: attrSize.width, height: attrSize.height)

                let path = NSBezierPath(roundedRect: centeredRect, xRadius: centeredRect.size.height / 2, yRadius: centeredRect.size.height / 2)
                NSColor.red.withAlphaComponent(0.93).setFill()
                path.fill()
                
                attrStr.draw(with: centeredTextRect, options: .usesLineFragmentOrigin)
            }
        }

        if let count = counts[2], count > 0 {
            let nf = NumberFormatter()
            nf.numberStyle = .none
            if let str = nf.string(from: NSNumber(integerLiteral: count)) {
                let attrs = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: NSColor.black]
                let attrStr = NSAttributedString(string: str, attributes: attrs)
                let attrSize = attrStr.size()
                let possibleSize = attrSize
                let maxedSize = CGSize(width: max(possibleSize.width, bounds.size.width * 0.3), height: max(possibleSize.height, bounds.size.height * 0.3))
                let textSize = CGSize(width: max(maxedSize.width, maxedSize.height), height: maxedSize.height)
                let size = CGSize(width: textSize.width + 16, height: textSize.height)
                let centeredRect = CGRect(x: (bounds.size.width / 2) - (size.width / 2), y: (bounds.size.height / 2) - (size.height / 2), width: size.width, height: size.height).offsetBy(dx: bounds.size.width / 4 + 5, dy: bounds.size.height / -4 - 5)
                let centeredTextRect = CGRect(x: (centeredRect.size.width / 2) + centeredRect.origin.x - (attrSize.width / 2), y: (centeredRect.size.height / 2) + centeredRect.origin.y - (attrSize.height / 2), width: attrSize.width, height: attrSize.height)

                let path = NSBezierPath(roundedRect: centeredRect, xRadius: centeredRect.size.height / 2, yRadius: centeredRect.size.height / 2)
                NSColor.green.withAlphaComponent(0.93).setFill()
                path.fill()
                
                attrStr.draw(with: centeredTextRect, options: .usesLineFragmentOrigin)
            }
        }

        if let count = counts[3], count > 0 {
            let nf = NumberFormatter()
            nf.numberStyle = .none
            if let str = nf.string(from: NSNumber(integerLiteral: count)) {
                let attrs = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: NSColor.white]
                let attrStr = NSAttributedString(string: str, attributes: attrs)
                let attrSize = attrStr.size()
                let possibleSize = attrSize
                let maxedSize = CGSize(width: max(possibleSize.width, bounds.size.width * 0.3), height: max(possibleSize.height, bounds.size.height * 0.3))
                let textSize = CGSize(width: max(maxedSize.width, maxedSize.height), height: maxedSize.height)
                let size = CGSize(width: textSize.width + 16, height: textSize.height)
                let centeredRect = CGRect(x: (bounds.size.width / 2) - (size.width / 2), y: (bounds.size.height / 2) - (size.height / 2), width: size.width, height: size.height).offsetBy(dx: bounds.size.width / -4 - 5, dy: bounds.size.height / -4 - 5)
                let centeredTextRect = CGRect(x: (centeredRect.size.width / 2) + centeredRect.origin.x - (attrSize.width / 2), y: (centeredRect.size.height / 2) + centeredRect.origin.y - (attrSize.height / 2), width: attrSize.width, height: attrSize.height)

                let path = NSBezierPath(roundedRect: centeredRect, xRadius: centeredRect.size.height / 2, yRadius: centeredRect.size.height / 2)
                NSColor.blue.withAlphaComponent(0.93).setFill()
                path.fill()

                attrStr.draw(with: centeredTextRect, options: .usesLineFragmentOrigin)
            }
        }

        if let count = counts[4], count > 0 {
            let nf = NumberFormatter()
            nf.numberStyle = .none
            if let str = nf.string(from: NSNumber(integerLiteral: count)) {
                let attrs = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: NSColor.black]
                let attrStr = NSAttributedString(string: str, attributes: attrs)
                let attrSize = attrStr.size()
                let possibleSize = attrSize
                let maxedSize = CGSize(width: max(possibleSize.width, bounds.size.width * 0.3), height: max(possibleSize.height, bounds.size.height * 0.3))
                let textSize = CGSize(width: max(maxedSize.width, maxedSize.height), height: maxedSize.height)
                let size = CGSize(width: textSize.width + 16, height: textSize.height)
                let centeredRect = CGRect(x: (bounds.size.width / 2) - (size.width / 2), y: (bounds.size.height / 2) + (size.height / 2), width: size.width, height: size.height).offsetBy(dx: bounds.size.width / -4 - 5, dy: 5)
                let centeredTextRect = CGRect(x: (centeredRect.size.width / 2) + centeredRect.origin.x - (attrSize.width / 2), y: (centeredRect.size.height / 2) + centeredRect.origin.y - (attrSize.height / 2), width: attrSize.width, height: attrSize.height)

                let path = NSBezierPath(roundedRect: centeredRect, xRadius: centeredRect.size.height / 2, yRadius: centeredRect.size.height / 2)
                NSColor.yellow.withAlphaComponent(0.93).setFill()
                path.fill()
                
                attrStr.draw(with: centeredTextRect, options: .usesLineFragmentOrigin)
            }
        }
    }
}
