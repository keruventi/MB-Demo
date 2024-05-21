//
//  UserDetailViewModel.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import Foundation
import UIKit

class UserDetailViewModel {
    var userDetail: GitHubUserDetail?
    var onError: ((String) -> Void)?
    var onUserDetailFetched: (() -> Void)?
    
    func fetchUserDetail(for id: String) {
        NetworkService.shared.fetchData(from: .fetchUserDetail(userId: id)) { (result: Result<GitHubUserDetail, APIError>) in
            switch result {
            case .success(let userDetail):
                self.userDetail = userDetail
                self.onUserDetailFetched?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        NetworkService.shared.fetchImage(from: urlString) { image in
            completion(image)
        }
    }
}
