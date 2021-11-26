//
//  Review.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/19/20.
//

import Foundation

struct ServerReviewsOfUserResponse: Codable {
    let userReviews: [UserReview]
}

class UserReview: Codable {
    init(title: String, comments: String, date: String, rating: Int, bathroomID: String, upvotes: Int) {
        self.title = title
        self.comments = comments
        self.date = date
        self.rating = rating
        self.bathroomID = bathroomID
        self.upvotes = upvotes
    }
    
    let title: String
    let comments: String
    let date: String
    let rating: Int
    let bathroomID: String
    let upvotes: Int
}
