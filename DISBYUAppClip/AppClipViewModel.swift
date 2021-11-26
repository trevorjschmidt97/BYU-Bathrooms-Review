//
//  AppClipViewModel.swift
//  DISBYUAppClip
//
//  Created by Trevor Schmidt on 4/18/21.
//

import Foundation

class AppClipViewModel: Codable {
    let floor: Int
    let name: String
    let ratings: [ratings]
    let reviews: [reviews]
}

class ratings: Codable {
    let userID: String
    let rating: Int
}

class reviews: Codable {
    let userID: String
    let username: String
    
}
