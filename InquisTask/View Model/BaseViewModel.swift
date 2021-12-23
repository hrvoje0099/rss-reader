//
//  BaseViewModel.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 22.12.2021..
//

import UIKit

protocol BaseViewModelProtocol {
    var isLoading: Bool { get }
    var infoMessage: String? { get }
    
    var reloadTableView: (()->())? { get set }
    var updateLoadingStatus: (()->())? { get set }
    var showInfoMessageClosure: (()->())? { get set }
}

enum InfoMessage: Error {
    case wrongText
    case wrongURL
    case feedIsValid
}

class BaseViewModel: BaseViewModelProtocol {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - PROTOCOL PROPERTIES
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var infoMessage: String? {
        didSet {
            self.showInfoMessageClosure?()
        }
    }
    
    // MARK: - PROTOCOL CLOSURES
    
    var reloadTableView: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var showInfoMessageClosure: (()->())?
    
    // MARK: - PUBLIC METHODS
    
    func processInfoMessage(message: Error) {
        switch message {
        case RequestError.getFeedsError:
            self.infoMessage = "Error while retrieving feeds!"
        case RequestError.deleteFeedError:
            self.infoMessage = "Error while deleting feeds!"
        case RequestError.saveFeedError:
            self.infoMessage = "Error while saving feeds!"
        case RequestError.storiesUrlError:
            self.infoMessage = "Wrong URL to get stories!"
        case RequestError.networkingError(let error):
            self.infoMessage = "Networking error: \(error)"
        case RequestError.pageNotFound:
            self.infoMessage = "404 Page Not Found"
        case RequestError.requestFailed(let responseCode):
            self.infoMessage = "Request failed, code: \(responseCode)"
        case RequestError.serverError(let responseCode):
            self.infoMessage = "Server error, code: \(responseCode)"
        case RequestError.feedParsingError(let error):
            self.infoMessage = "Feed parsing error: \(error)"
        case RequestError.wrongModel:
            self.infoMessage = "Not an RSS model!"
        case InfoMessage.wrongText:
            self.infoMessage = "Wrong text!"
        case InfoMessage.wrongURL:
            self.infoMessage = "Wrong URL!"
        case InfoMessage.feedIsValid:
            self.infoMessage = "Feed is valid and added!"
        default:
            self.infoMessage = "Unknown error!"
        }
    }
}
