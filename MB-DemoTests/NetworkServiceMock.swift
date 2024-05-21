//
//  NetworkServiceMock.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/21/24.
//

import XCTest
import UIKit
@testable import MB_Demo

class NetworkServiceMock: NetworkServiceProtocol {

    var nextData: Data?
    var nextError: APIError?
    var nextImage: UIImage?

    func fetchData<T: Decodable>(from requestType: RequestType, completion: @escaping (Result<T, APIError>) -> Void) {
        if let error = nextError {
            completion(.failure(error))
        } else if let data = nextData {
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.invalidResponse))
            }
        } else {
            completion(.failure(.invalidData))
        }
    }

    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let error = nextError {
            completion(nil)
        } else {
            completion(nextImage)
        }
    }
}
