//
//  Leader.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/26/20.
//

import Foundation

struct ServerLeadersResponse: Codable {
    let leaders: [Leader]
}

class Leader: Codable {
    let username: String
    let upvotes: Int
}
