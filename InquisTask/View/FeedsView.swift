//
//  FeedsView.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 16.12.2021..
//

import UIKit

final class FeedsView: UIView {
    
    // MARK: - PROPERTIES
    
    var feedsTableView = UITableView()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
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
        feedsTableView = UITableView(frame: frame, style: .grouped)
        feedsTableView.translatesAutoresizingMaskIntoConstraints = false
        feedsTableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.FeedCellReuseIdentifier)
        
        addSubview(feedsTableView)
        
        activityIndicator.center = feedsTableView.center
        addSubview(activityIndicator)
    }
    
    private func setConstraintsForElements() {
        NSLayoutConstraint.activate([
            feedsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            feedsTableView.topAnchor.constraint(equalTo: self.topAnchor),
            feedsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            feedsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: feedsTableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: feedsTableView.centerYAnchor)
        ])
    }
}
