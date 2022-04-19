//
//  WebView.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 19.12.2021..
//

import UIKit
import WebKit

final class WebView: UIView {
    
    // MARK: - PROPERTIES
    
    lazy var wkWebView: WKWebView = {
        let wkWebView = WKWebView()
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        return wkWebView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .black
        return activityIndicator
    }()
    
    // MARK: - INIT
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupView() {
        addElementsOnView()
        setConstraintsForElements()
    }
    
    private func addElementsOnView() {
        addSubview(wkWebView)
        addSubview(activityIndicator)
    }
    
    private func setConstraintsForElements() {
        NSLayoutConstraint.activate([
            wkWebView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            wkWebView.topAnchor.constraint(equalTo: self.topAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: wkWebView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: wkWebView.centerYAnchor)
        ])
    }
}
