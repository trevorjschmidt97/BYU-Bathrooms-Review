//
//  Info.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/19/20.
//

import Foundation

struct ServerInfoOfUserResponse: Codable {
    let userInfo: UserInfo
}

class UserInfo: Codable {
    init(username: String, numRatings: Int, avgRating: Float, num5Reviews: Int,
         num4Reviews: Int, num3Reviews: Int, num2Reviews: Int, num1Reviews: Int, reviewScore: Int) {
        self.username = username
        self.numRatings = numRatings
        self.avgRating = avgRating
        self.num5Reviews = num5Reviews
        self.num4Reviews = num4Reviews
        self.num3Reviews = num3Reviews
        self.num2Reviews = num2Reviews
        self.num1Reviews = num1Reviews
        self.reviewScore = reviewScore
    }
    
    
    let username: String
    let avgRating: Float
    let num5Reviews: Int
    let num4Reviews: Int
    let num3Reviews: Int
    let num2Reviews: Int
    let num1Reviews: Int
    let numRatings: Int
    let reviewScore: Int
}
