//
//  IndividualBathroomReview.swift
//  SpecificBathroomAppClip
//
//  Created by Trevor Schmidt on 4/20/21.
//
import Foundation

class IndividualBathroomReview {
    init(username: String, title: String, comments: String, date: String, rating: Int, upvotes: Int) {
        self.username = username
        self.title = title
        self.comments = comments
        self.date = date
        self.rating = rating
        self.upvotes = upvotes
    }
    
    let username: String
    let title: String
    let comments: String
    let date: String
    let rating: Int
    let upvotes: Int
}
 
