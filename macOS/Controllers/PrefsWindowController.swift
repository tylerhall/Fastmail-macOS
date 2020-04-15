//
//  PrefsWindowController.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

class PrefsWindowController: NSWindowController {

    @IBOutlet weak var configTextView: NSTextView!
    @IBOutlet weak var configPlaceholderLabel: NSTextField!
    
    var oldAccountsConfigText: String?

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.delegate = self
        
        oldAccountsConfigText = Constants.accountsConfigText ?? ""
        configTextView.string = oldAccountsConfigText!
        updateConfigPlaceholder()
    }
    
    func updateConfigPlaceholder() {
        if configTextView.string.count == 0 {
            configPlaceholderLabel.isHidden = false
        } else {
            configPlaceholderLabel.isHidden = true
        }
    }
}

extension PrefsWindowController: NSTextDelegate {
    
    func textDidChange(_ notification: Notification) {
        updateConfigPlaceholder()
        Constants.accountsConfigText = configTextView.string
    }
}

extension PrefsWindowController: NSWindowDelegate {

    func windowWillClose(_ notification: Notification) {
        Constants.accountsConfigText = configTextView.string
        
        if configTextView.string != oldAccountsConfigText {
            let appDelegate = NSApp.delegate as! AppDelegate
            _ = appDelegate.createAccountWindowControllers()
            appDelegate.showAllAccountWindows()
        }
    }
}
