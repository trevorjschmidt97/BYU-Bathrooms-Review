//
//  Review.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/19/20.
//

import Foundation

struct ServerReviewsInBathroomResponse: Codable {
    let reviews: [Review]
}

class Review: Codable {
    let ratingID: Int
    let title: String
    let comments: String
    let date: Date//TODO
    let rating: Int
    let login: String
    let upvotes: Int
    let userLiked: Int
    let userDisliked: Int
}

class fireReview {
    init(userID: String, username: String, title: String, comments: String, date: String, rating: Int, upvotes: Int, userLike: Int) {
        self.userID = userID
        self.username = username
        self.title = title
        self.comments = comments
        self.date = date
        self.rating = rating
        self.upvotes = upvotes
        self.userLike = userLike
    }
    
    let userID: String
    let username: String
    let title: String
    let comments: String
    let date: String
    let rating: Int
    let upvotes: Int
    let userLike: Int
}
