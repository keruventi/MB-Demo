//
//  GitHubUser.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import Foundation

struct GitHubUser: Codable {
    let id: Int
    let userId: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "login"
        case avatarUrl = "avatar_url"
    }
}

