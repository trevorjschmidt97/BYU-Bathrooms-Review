//
//  InsertionResult.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/19/20.
//

import Foundation

struct ServerInsertionResponse: Codable {
    let result: InsertionResult
}

class InsertionResult: Codable {
    let resultString: String
}
