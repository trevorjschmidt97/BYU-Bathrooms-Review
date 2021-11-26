//
//  BathroomCell.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/23/20.
//

import UIKit
import Cosmos
import FirebaseDatabase
import StoreKit

class ReviewCell: UITableViewCell {
    // Db refs
    let bathroomsInfoRef = Database.database().reference().child("bathroomsInfo")
    let usersRef = Database.database().reference().child("users")
    
    // Labels and so forth
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ratingCosmosView: CosmosView!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var dislikeButton: UIButton!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    // Meta data
    var ratingID: Int!
    var buildingID: String!
    var bathroomNumber: String!
    var username: String!
    var userID: String!
    
    // Click Like
    @IBAction func clickLike(_ sender: Any) {
        // If logged in
        if Globals.userID == "0" {
            let alert = UIAlertController(title: "You Must Sign In To Upvote This Review", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.parentViewController?.present(alert, animated: true, completion: nil)
            return
        }
        
        // Get this to mess with it later
        var count = Int(upvotesLabel.text!)
        
        // Three cases:
        // Case 1: User has not left a rating, upvote like, leave dislike to nothing
        // Case 2: User has dislike the rating, upvote like, change dislike to nothing
        // Case 3: User has liked the rating, change like to nothing
        if let currentLikeImage = likeButton.image(for: .normal) {
            if let currentDislikeImage = dislikeButton.image(for: .normal) {
                // Case 1
                if UIImage(systemName: "hand.thumbsup") == currentLikeImage { // upvote is not highlighted
                    bathroomsInfoRef.child(buildingID).child(bathroomNumber).child("reviews").child(userID).child("upvotes").child(Globals.userID).setValue(1)
                    
                    usersRef.child(userID).child("reviews").child(buildingID + "_" + bathroomNumber).child("upvotes").child(Globals.userID).setValue(1)
                    likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                    count! += 1
                    // And case 2
                    if UIImage(systemName: "hand.thumbsdown.fill") == currentDislikeImage {
                        dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
                        count! += 1
                    }
                } else {
                    // Case 3
                    likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
                    count! -= 1
                    bathroomsInfoRef.child(buildingID).child(bathroomNumber).child("reviews").child(userID).child("upvotes").child(Globals.userID).setValue(0)
                    usersRef.child(userID).child("reviews").child(buildingID + "_" + bathroomNumber).child("upvotes").child(Globals.userID).setValue(0)
                }
            }
        }
        upvotesLabel.text = String(count!)
    }
    
    @IBAction func clickDislike(_ sender: Any) {
        // If signed in
        if Globals.userID == "0" {
            let alert = UIAlertController(title: "You Must Sign In To Downvote This Review", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.parentViewController?.present(alert, animated: true, completion: nil)
            return
        }
        
        // Get this to mess with it later
        var count = Int(upvotesLabel.text!)
    
        // Three cases:
        // Case 1: User has not left a rating, upvote dislike, leave like to nothing
        // Case 2: User has liked the rating, upvote dislike, change like to nothing
        // Case 3: User has disliked the rating, change dislike to nothing
        if let currentLikeImage = likeButton.image(for: .normal) {
            if let currentDislikeImage = dislikeButton.image(for: .normal) {
            
                // Case 1
                if UIImage(systemName: "hand.thumbsdown") == currentDislikeImage {
                    bathroomsInfoRef.child(buildingID).child(bathroomNumber).child("reviews").child(userID).child("upvotes").child(Globals.userID).setValue(-1)
                    usersRef.child(userID).child("reviews").child(buildingID + "_" + bathroomNumber).child("upvotes").child(Globals.userID).setValue(-1)
                    dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
                    count! -= 1
                    // And case 2
                    if UIImage(systemName: "hand.thumbsup.fill") == currentLikeImage {
                        likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
                        count! -= 1
                    }
                } else {
                    // Case 3
                    dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
                    count! += 1
                    bathroomsInfoRef.child(buildingID).child(bathroomNumber).child("reviews").child(userID).child("upvotes").child(Globals.userID).setValue(0)
                    usersRef.child(userID).child("reviews").child(buildingID + "_" + bathroomNumber).child("upvotes").child(Globals.userID).setValue(0)
                }
            }
        }
        upvotesLabel.text = String(count!)
    }
}




// LEGACY CODE
//        Globals.store.pushLike(ratingID: String(ratingID), userID: Globals.userID) {
//            (InsertionResult) in
//
//            switch InsertionResult {
//            case let .success(result):
//                print(result.resultString)
//            case let .failure(error):
////                self.showToast(message: "Error liking review, try later", good: false)
//                print("Error pushing like: \(error)")
//                return
//            }
//        }

//        Globals.store.pushDislike(ratingID: String(ratingID), userID: Globals.userID) {
//            (InsertionResult) in
//
//            switch InsertionResult {
//            case let .success(result):
//                print(result.resultString)
//            case let .failure(error):
////                self.showToast(message: "Error disliking review, try later", good: false)
//                print("Error pushing like: \(error)")
//                return
//            }
//        }
