//
//  WebViewController.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 19.12.2021..
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    private lazy var webView: WebView = {
        let webView = WebView()
        webView.wkWebView.navigationDelegate = self
        return webView
    }()
    
    private var pageURL: URL
    
    // MARK: - INIT
    
    init(pageURL: URL) {
        self.pageURL = pageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWKWebView()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupWKWebView() {
        webView.wkWebView.load(URLRequest(url: pageURL))
        webView.wkWebView.allowsBackForwardNavigationGestures = true
    }
}

// MARK: - WK NAVIGATION DELEGATE

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.webView.activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.webView.activityIndicator.stopAnimating()
    }
}
