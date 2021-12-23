//
//  StoryCell.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 19.12.2021..
//

import UIKit

final class StoryCell: UITableViewCell {
    
    static let StoryCellReuseIdentifier = "StoryCell"
    
    // MARK: - PROPERTIES
    
    let storyCreatedDateLabel: UILabel = {
        let storyCreatedDateLabel = UILabel()
        storyCreatedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        return storyCreatedDateLabel
    }()
    
    let storyNameLabel: UILabel = {
        let storyNameLabel = UILabel()
        storyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        storyNameLabel.numberOfLines = 0
        return storyNameLabel
    }()
 
    // MARK: - INIT
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupView() {
        accessoryType = .disclosureIndicator
        
        addElementsOnView()
        setConstraintsForElements()
    }
    
    private func addElementsOnView() {
        addSubview(storyCreatedDateLabel)
        addSubview(storyNameLabel)
    }
    
    private func setConstraintsForElements() {
        NSLayoutConstraint.activate([
            storyCreatedDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            storyCreatedDateLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            
            storyNameLabel.topAnchor.constraint(equalTo: storyCreatedDateLabel.bottomAnchor, constant: 10),
            storyNameLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            storyNameLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -20),
            storyNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
}
