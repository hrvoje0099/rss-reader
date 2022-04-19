//
//  AddRSSView.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 17.12.2021..
//

import UIKit

final class AddRSSView: UIView {
    
    // MARK: - ACTION CLOSURES
    
    var onProcessRssUrl: (UITextField) -> Void = {_ in }
    
    // MARK: - PROPERTIES
    
    private lazy var urlTextField: UITextField = {
        let urlTextField = UITextField()
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        urlTextField.placeholder = "RSS URL"
        urlTextField.textAlignment = .center
        urlTextField.backgroundColor = .systemBackground
        urlTextField.setBottomBorder()
        return urlTextField
    }()
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton(type: .system)
        addButton.configuration = UIButton.Configuration.filled()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("ADD", for: .normal)
        addButton.addTarget(self, action: #selector(processRssUrl(_:)), for: .touchUpInside)
        return addButton
    }()
    
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .left
        infoLabel.numberOfLines = 0
        return infoLabel
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - INIT
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addElementsOnView()
        setConstraintsForElements()
    }
    
    private func addElementsOnView() {
        addSubview(urlTextField)
        addSubview(addButton)
        addSubview(infoLabel)
        
        activityIndicator.center = self.center
        addSubview(activityIndicator)
    }
    
    private func setConstraintsForElements() {
        NSLayoutConstraint.activate([
            urlTextField.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 10),
            urlTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            urlTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            urlTextField.heightAnchor.constraint(equalToConstant: 30),
            
            addButton.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 15),
            addButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            infoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: - SELECTORS METHODS
    
    @objc private func processRssUrl(_ textField: UITextField) {
        onProcessRssUrl(urlTextField)
    }
}
