//
//  Info.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/19/20.
//

import Foundation

struct ServerInfoOfBathroomResponse: Codable {
    let info: Info
}

class Info: Codable {
    
    init(buildingID: String, bathroomName: String, bathroomNumber: String, numReviews: Int, avgRating: Float, num5Reviews: Int,
         num4Reviews: Int, num3Reviews: Int, num2Reviews: Int, num1Reviews: Int, userRating: Int) {
        self.buildingID = buildingID
        self.bathroomName = bathroomName
        self.bathroomNumber = bathroomNumber
        self.numReviews = numReviews
        self.avgRating = avgRating
        self.num5Reviews = num5Reviews
        self.num4Reviews = num4Reviews
        self.num3Reviews = num3Reviews
        self.num2Reviews = num2Reviews
        self.num1Reviews = num1Reviews
        self.userRating = userRating
    }
    
    let buildingID: String
    let bathroomName: String
    let bathroomNumber: String
    let numReviews: Int
    let avgRating: Float
    let num5Reviews: Int
    let num4Reviews: Int
    let num3Reviews: Int
    let num2Reviews: Int
    let num1Reviews: Int
    let userRating: Int
}
