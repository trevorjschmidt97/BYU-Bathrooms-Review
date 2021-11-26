//
//  DatabaseManager.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 3/25/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let rootRef = Database.database().reference()

    public func test() {
        rootRef.child("test").setValue(["sometime": true])
    }
    
    
}
