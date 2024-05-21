//
//  UsersViewModel.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import Foundation
import UIKit

class UsersViewModel {
    var users: [GitHubUser] = []
    var onError: ((String) -> Void)?
    var onUsersFetched: (() -> Void)?
    
    func fetchUsers(from lastItemId: Int = 0) {
        NetworkService.shared.fetchData(from: .fetchUsers(perPage: 20, since: lastItemId)) { (result: Result<[GitHubUser], APIError>) in
            switch result {
            case .success(let users):
                self.users.append(contentsOf: users)
                self.onUsersFetched?()
            case .failure(let error):
                self.onError?(error.description)
            }
        }
    }
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        NetworkService.shared.fetchImage(from: urlString) { image in
            completion(image)
        }
    }
}
