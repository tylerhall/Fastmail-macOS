//
//  MainWindowController.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa
import WebKit

class AccountWindowController: NSWindowController {

    @IBOutlet weak var webView: FMWebView!

    weak var account: Account!
    var windowDidLoadCallback: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func windowDidLoad() {
        shouldCascadeWindows = false
        window?.title = account.name
        window?.setFrameUsingName(NSWindow.FrameAutosaveName(account.url.absoluteString))
        windowFrameAutosaveName = NSWindow.FrameAutosaveName(account.url.absoluteString)
        window?.isExcludedFromWindowsMenu = true
        super.windowDidLoad()
        windowDidLoadCallback?()
    }
}
