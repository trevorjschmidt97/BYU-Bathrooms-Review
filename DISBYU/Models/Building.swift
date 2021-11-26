//
//  Building.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/18/20.
//

import Foundation

struct ServerBuildingsResponse: Codable {
    let buildings: [Building]
}

class Building: NSObject, Codable {
    let buildingID: String
    let fullBuildingName: String
    let buildingLocationLat: Float
    let buildingLocationLong: Float
}
