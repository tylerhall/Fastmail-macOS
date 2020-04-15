//
//  FMWebView.swift
//  Fastmail
//
//  Created by Tyler Hall on 3/19/20.
//  Copyright © 2020 Your Company. All rights reserved.
//

import Cocoa
import WebKit

class FMWebView: WKWebView {

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        navigationDelegate = self
    }
}

extension FMWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, let domain = url.host {
            if !domain.hasSuffix("fastmail.com") {
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
}
