//
//  NetworkService.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/18/24.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(from requestType: RequestType, completion: @escaping (Result<T, APIError>) -> Void)
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private init() {}
    private var imageCache = NSCache<NSString, UIImage>()
    
    func fetchData<T: Decodable>(from requestType: RequestType, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = requestType.url else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let errorMessage = self.handleErrorResponse(data)
                completion(.failure(.networkError(message: errorMessage)))
                return
            }
            
            if let error = error {
                completion(.failure(.networkError(message: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch (let error) {
                print("Data object decoding failed with error: \(error) \n \(error.localizedDescription)")
                completion(.failure(.invalidResponse))
            }
        }
        task.resume()
    }
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }
            self.imageCache.setObject(image, forKey: NSString(string: urlString))
            completion(image)
        }.resume()
    }
}

extension NetworkService {
    func handleErrorResponse(_ data: Data?) -> String {
        guard let data = data else {
            return APIError.invalidData.description
        }
        
        do {
            let response = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            return response.message
        } catch {
            return APIError.invalidResponse.description
        }
        
    }
}


