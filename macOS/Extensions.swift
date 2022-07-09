//
//  Extensions-Shared.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

extension Double {

    // It's dumb, but I swear I end up having to dump a number into some type
    // of storage that only accepts a String way more often than I care to think about.
    func stringValue() -> String {
        return String(format:"%f", self)
    }
}

extension NSNotification.Name {
    func post(_ object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
}

extension TimeInterval {

    // let foo: TimeInterval = 6227
    // foo.durationString() -> "2h"
    // foo.durationString(2) -> "1h 44m"
    // foo.durationString(3) -> "1h 43m 47s"
    func durationString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        return formatter.string(from: self)!
    }
}

extension Date {
    
    // let d = Date() -> Mar 12, 2020 at 1:51 PM
    // d.stringify() -> "1584039099.486827"
    func stringify() -> String {
        return timeIntervalSince1970.stringValue()
    }

    // Date.unstringify("1584039099.486827") -> Mar 12, 2020 at 1:51 PM
    static func unstringify(_ ts: String) -> Date {
        let dbl = Double(ts) ?? 0
        return Date(timeIntervalSince1970: dbl)
    }
}

extension String {

    // An incredibly lenient and forgiving way to get a numeric String
    // out of another string - typically one provided by the user.
    // You shouldn't rely on this for anythign truly mission critical.
    func numberString() -> String? {
        let strippedStr = trimmingCharacters(in: .whitespacesAndNewlines)
        let isNegative = strippedStr.hasPrefix("-")
        let allowedCharSet = CharacterSet(charactersIn: ".,0123456789")
        let filteredStr = components(separatedBy: allowedCharSet.inverted).joined()
        if (count(of: ".") + count(of: ",")) > 1 { return nil }
        return (isNegative ? "-" : "") + filteredStr
    }

    // Number of times a character occurs within a string.
    func count(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }

    // Returns an array of substrings delimited by whitespace - and also
    // combines tokens inside matching quotes into a single token. I don't
    // claim this to be pefect in every edge case - but I haven't encountered
    // a bug yet 🤷‍♀️.
    // "My name is Tim Apple".tokenize() -> ["My", "name", "is", "Tim", "Apple"]
    // "I hope the \"SF Giants\" have a \"better season\" this year" -> ["I", "hope", "the", "SF Giants", "have", "a", "better season", "this", "year"]
    @available(OSX 10.15, iOS 13, *)
    func tokenize() -> [String] {
        enum State {
            case Normal
            case InsideAQuote
        }
        
        let theString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var tokens = [String]()
        var state = State.Normal
        let delimeters = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "\""))
        let quote = CharacterSet(charactersIn: "\"")

        let scanner = Scanner(string: theString)
        scanner.charactersToBeSkipped = .none
        
        while !scanner.isAtEnd {
            if state == .Normal {
                if let token = scanner.scanCharacters(from: delimeters.inverted) {
                    tokens.append(token.trimmingCharacters(in: .whitespacesAndNewlines))
                } else if let delims = scanner.scanCharacters(from: delimeters) {
                    if delims.hasSuffix("\"") {
                        state = .InsideAQuote
                    }
                }
            } else {
                if let token = scanner.scanCharacters(from: quote.inverted) {
                    tokens.append(token.trimmingCharacters(in: .whitespacesAndNewlines))
                    state = .Normal
                }
            }
        }

        return tokens
    }
}

extension Dictionary {

    // Combines self with another dictionary.
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension NSView {
    func pinEdges(to other: NSView, offset: CGFloat = 0, animate: Bool = false) {
        if animate {
            animator().leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: offset).isActive = true
        } else {
            leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: offset).isActive = true
            trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: other.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
        }
    }
}

extension NSTableView {
    func reloadOnMainThread(_ complete: (() -> ())? = nil) {
        DispatchQueue.main.async {
            self.reloadData()
            complete?()
        }
    }

    func reloadMaintainingSelection(_ complete: (() -> ())? = nil) {
        let oldSelectedRowIndexes = selectedRowIndexes
        reloadOnMainThread {
            if oldSelectedRowIndexes.count == 0 {
                if self.numberOfRows > 0 {
                    self.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
                }
            } else {
                self.selectRowIndexes(oldSelectedRowIndexes, byExtendingSelection: false)
            }
        }
    }

    func selectFirstPossibleRow() {
        for i in 0..<numberOfRows {
            if let delegate = delegate, let shouldSelect = delegate.tableView?(self, shouldSelectRow: i) {
                if shouldSelect {
                    selectRowIndexes(IndexSet(integer: i), byExtendingSelection: false)
                    return
                }
            } else {
                selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
            }
        }
    }

    func selectLastPossibleRow() {
        for i in stride(from: numberOfRows - 1, to: 0, by: -1) {
            if let delegate = delegate, let shouldSelect = delegate.tableView?(self, shouldSelectRow: i) {
                if shouldSelect {
                    selectRowIndexes(IndexSet(integer: i), byExtendingSelection: false)
                    return
                }
            } else {
                selectRowIndexes(IndexSet(integer: numberOfRows - 1), byExtendingSelection: false)
            }
        }
    }
}

extension String {

    // I should really just stop using these and switch to one of the better, full-featured attributed string
    // libraries, but meh. This stuff works for now.
    func boldString(textColor: NSColor = NSColor.textColor) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: self)
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSRange(self.startIndex..., in: self))
        attrStr.addAttribute(NSAttributedString.Key.font, value: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize), range: NSRange(self.startIndex..., in: self))
        return attrStr
    }

    func coloredAttributedString(textColor: NSColor = NSColor.textColor) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: self)
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSRange(self.startIndex..., in: self))
        attrStr.addAttribute(NSAttributedString.Key.font, value: NSFont.systemFont(ofSize: NSFont.systemFontSize), range: NSRange(self.startIndex..., in: self))
        return attrStr
    }
}

extension NSImage {

    func writeJPGToURL(_ url: URL, quality: Float = 0.7) -> Bool {
        let properties = [NSBitmapImageRep.PropertyKey.compressionFactor: quality]
        guard let imageData = self.tiffRepresentation else { return false }
        guard let imageRep = NSBitmapImageRep(data: imageData) else { return false }
        guard let fileData = imageRep.representation(using: .jpeg, properties: properties) else { return false }

        do {
            try fileData.write(to: url)
        } catch {
            return false
        }

        return true
    }
    
    func writePNGToURL(_ url: URL) -> Bool {
        guard let imageData = self.tiffRepresentation else { return false }
        guard let imageRep = NSBitmapImageRep(data: imageData) else { return false }
        guard let fileData = imageRep.representation(using: .png, properties: [:]) else { return false }

        do {
            try fileData.write(to: url)
        } catch {
            return false
        }

        return true
    }

    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()

        return image
    }
}


extension NSEvent {
    var isRightClick: Bool {
        let rightClick = (self.type == .rightMouseDown)
        let controlClick = self.modifierFlags.contains(.control)
        return rightClick || controlClick
    }
}

extension URL {
    func appendingQueryItems(_ queryItems: [String: String]) -> URL {
        var urlAbsString = self.absoluteString
        var separator = (self.query == nil) ? "?" : "&"
        
        for (k, v) in queryItems {
            urlAbsString += separator + k + "=" + v.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            separator = "&"
        }
        return URL(string: urlAbsString) ?? self;
    }
    
}
