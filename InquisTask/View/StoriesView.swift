//
//  StoriesView.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 19.12.2021..
//

import UIKit

final class StoriesView: UIView {
    
    // MARK: - PROPERTIES
    
    var storiesTableView = UITableView()
    
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
        storiesTableView = UITableView(frame: frame, style: .grouped)
        storiesTableView.translatesAutoresizingMaskIntoConstraints = false
        storiesTableView.register(StoryCell.self, forCellReuseIdentifier: StoryCell.StoryCellReuseIdentifier)
        
        addSubview(storiesTableView)
        
        activityIndicator.center = storiesTableView.center
        addSubview(activityIndicator)
    }
    
    private func setConstraintsForElements() {
        NSLayoutConstraint.activate([
            storiesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            storiesTableView.topAnchor.constraint(equalTo: self.topAnchor),
            storiesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            storiesTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: storiesTableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: storiesTableView.centerYAnchor)
        ])
    }
}
