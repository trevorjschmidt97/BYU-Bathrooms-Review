//
//  Bathroom.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/19/20.
//

import Foundation

struct ServerBathroomsInBuildingResponse: Codable {
    let bathrooms: [Bathroom]
}

class Bathroom: Codable {
    init(buildingID: String, bathroomName: String, bathroomNumber: String, floorNumber: Int, numReviews: Int, avgRating: Float) {
        self.buildingID = buildingID
        self.bathroomName = bathroomName
        self.bathroomNumber = bathroomNumber
        self.floorNumber = floorNumber
        self.numReviews = numReviews
        self.avgRating = avgRating
    }
    
    var buildingID: String
    var bathroomName: String
    var bathroomNumber: String
    var floorNumber: Int
    var numReviews: Int
    var avgRating: Float
}
