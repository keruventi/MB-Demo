//
//  APIError.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/18/24.
//

import Foundation

enum APIError: Error, Equatable {
    case networkError(message: String)
    case invalidResponse
    case invalidData
    
    var description: String {
        switch self {
        case .networkError(let message):
            return message
        case .invalidResponse:
            return "The data couldn’t be read because it isn't in the correct format."
        case .invalidData:
            return "No data recieved from server. Please try again after sometime."
        }
    }
}
