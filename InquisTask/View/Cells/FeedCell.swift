//
//  FeedCell.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 16.12.2021..
//

import UIKit

final class FeedCell: UITableViewCell {
    
    static let FeedCellReuseIdentifier = "FeedCell"
    
    // MARK: - PROPERTIES
    
    let feedImageView: UIImageView = {
        let feedImageView = UIImageView ()
        feedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 0, weight: UIImage.SymbolWeight.light, scale: UIImage.SymbolScale.small)
        let image = UIImage(systemName: "questionmark.circle", withConfiguration: config)
        let imageView = UIImageView(image: image)
        
        feedImageView.image = imageView.image
        feedImageView.tintColor = .systemGray
        return feedImageView
    }()
    
    let feedNameLabel: UILabel = {
        let feedNameLabel = UILabel()
        feedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        feedNameLabel.textColor = .systemGray
        return feedNameLabel
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
        let avatarImageDimension: CGFloat = 45
        feedImageView.layer.cornerRadius = avatarImageDimension / 2
        
        accessoryType = .disclosureIndicator
        
        addElementsOnView()
        setConstraintsForElements(avatarImageDimension)
    }
    
    private func addElementsOnView() {
        addSubview(feedImageView)
        addSubview(feedNameLabel)
    }
    
    private func setConstraintsForElements(_ avatarImageDimension: CGFloat) {
        NSLayoutConstraint.activate([
            feedImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            feedImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            feedImageView.widthAnchor.constraint(equalToConstant: avatarImageDimension),
            feedImageView.heightAnchor.constraint(equalToConstant: avatarImageDimension),
            
            feedNameLabel.leadingAnchor.constraint(equalTo: feedImageView.trailingAnchor, constant: 16),
            feedNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
