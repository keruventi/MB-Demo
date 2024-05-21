//
//  RequestType.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/18/24.
//

import Foundation

enum RequestType {
    case fetchUsers(perPage: Int, since: Int)
    case fetchUserDetail(userId: String)
    
    var url: URL? {
        switch self {
        case .fetchUsers(let perPage, let since):
            return URL(string: "https://api.github.com/users?per_page=\(perPage)&since=\(since)")
        case .fetchUserDetail(let userId):
            return URL(string: "https://api.github.com/users/\(userId)")
        }
    }

}
