//
//  GitHubUserDetail.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import Foundation

struct GitHubUserDetail: Codable {
    var userName: String
    var id: Int
    var avatarUrl: String
    var name: String
    var company: String?
    var location: String
    var email: String?
    var bio: String?
    var followers: Int
    var following: Int
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case id
        case avatarUrl = "avatar_url"
        case name
        case company
        case location
        case email
        case bio
        case followers
        case following
        case updatedAt = "updated_at"
    }
    
    var bioText: String {
        guard let bio else { return "" }
        return bio
    }
    
    var lastActiveAt: String {
        guard let updatedAt = updatedAt else {
            return "Not Available"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss'Z'"

        guard let date = formatter.date(from: updatedAt) else {
            return "Not Active"
        }
        
        formatter.dateStyle = .medium
        let shortDate = formatter.string(from: date)
        return "Active on \(shortDate)"
    }
    
    var followersCount: String {
        return "\(followers) Followers \u{2022} \(following) Following"
    }
}
