//
//  Model.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 14.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable {
    let idClient: Int
    let idClientAccount: Int
    let clientCode: String
    let latitude: Double
    let longitude: Double
    let avatarHash: String?
    let statusOnline: Bool
    
    enum CodingKeys: String, CodingKey {
        case idClient = "IdClient"
        case idClientAccount = "IdClientAccount"
        case clientCode = "ClientCode"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case avatarHash = "AvatarHash"
        case statusOnline = "StatusOnline"
    }
}

typealias Users = [User]
