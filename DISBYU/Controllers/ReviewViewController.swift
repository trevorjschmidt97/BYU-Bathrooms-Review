//
//  ReviewViewController.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/24/20.
//

import UIKit
import FirebaseDatabase

class ReviewViewController: UIViewController {
    // Db References
    let rootRef = Database.database().reference()
    
//    IBOutlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var oneStarButton: UIButton!
    @IBOutlet weak var twoStarButton: UIButton!
    @IBOutlet weak var threeStarButton: UIButton!
    @IBOutlet weak var fourStarButton: UIButton!
    @IBOutlet weak var fiveStarButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!
    
//    User and app meta data
    var buildingID: String!
    var bathroomNumber: String!
    var bathroomID: String!
    var userRating: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Set up of title and review textfields/views
        titleTextField.delegate = self
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.lightGray.lighter(by: 15)?.cgColor
        titleTextField.layer.cornerRadius = 12
        reviewTextView.delegate = self
        reviewTextView.text = "Comments (Optional)"
        reviewTextView.textColor = UIColor.lightGray
        reviewTextView!.layer.borderWidth = 1
        reviewTextView!.layer.borderColor = UIColor.lightGray.lighter(by: 15)?.cgColor
        reviewTextView.layer.cornerRadius = 12
        
//        Setup of 5 star buttons
        oneStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        twoStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        threeStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        fourStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        fiveStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        
//        Fill in buttons if the user has already rated the bathroom
        if self.userRating > 0 {
            self.oneStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        if self.userRating > 1 {
            self.twoStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        if self.userRating > 2 {
            self.threeStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        if self.userRating > 3 {
            self.fourStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        if self.userRating > 4 {
            self.fiveStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
    }
    
//    Functions for when the user presses any of the buttons
    @IBAction func oneStarButtonPressed(_ sender: Any) {
        userRating = 1
        oneStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        twoStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        threeStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        fourStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        fiveStarButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    @IBAction func twoStarButtonPressed(_ sender: Any) {
        userRating = 2
        oneStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        twoStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        threeStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        fourStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        fiveStarButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    @IBAction func threeStarButtonPressed(_ sender: Any) {
        userRating = 3
        oneStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        twoStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        threeStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        fourStarButton.setImage(UIImage(systemName: "star"), for: .normal)
        fiveStarButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    @IBAction func fourStarButtonPressed(_ sender: Any) {
        userRating = 4
        oneStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        twoStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        threeStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        fourStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        fiveStarButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    @IBAction func fiveStarButtonPressed(_ sender: Any) {
        userRating = 5
        oneStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        twoStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        threeStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        fourStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        fiveStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
//    When the cancel button is pressed
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
//    When the send button is pressed
    @IBAction func sendButtonPressed(_ sender: Any) {
        print("send button pressed")
//       Ensure they leave a rating
        if userRating == 0 {
            let alert = UIAlertController(title: "Reviews must include a star-rating", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("star rating included")
//        Ensure they leave a title
        if titleTextField.hasText == false || titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let alert = UIAlertController(title: "Reviews must include a title", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        

        
        let title = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).encode()
//        title = title.replacingOccurrences(of: " ", with: "insertSpace")
//        title = title.replacingOccurrences(of: "’", with: "insertAsterisk")
//        title = title.replacingOccurrences(of: "'", with: "insertAsterisk")
//        title = title.replacingOccurrences(of: "/", with: "insertForwardSlash")
//        title = title.replacingOccurrences(of: "\\", with: "insertBackSlash")
//        title = title.replacingOccurrences(of: "%", with: "insertPercent")
        
        var comments = ""
        if reviewTextView.hasText {
            comments = reviewTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines).encode()
        }
        if comments == "Comments (Optional)" {
            comments = "No comment".encode()
        }
//        comments = comments.replacingOccurrences(of: " ", with: "insertSpace")
//        comments = comments.replacingOccurrences(of: "’", with: "insertAsterisk")
//        comments = comments.replacingOccurrences(of: "'", with: "insertAsterisk")
//        comments = comments.replacingOccurrences(of: "/", with: "insertForwardSlash")
//        comments = comments.replacingOccurrences(of: "\\", with: "insertBackSlash")
//        comments = comments.replacingOccurrences(of: "%", with: "insertPercent")
//        comments = comments.replacingOccurrences(of: "\n", with: "insertNewLine")
        
//        Push that review to the db
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        

        // update bathroom's review
        rootRef.child("bathroomsInfo").child(buildingID).child(bathroomNumber).child("reviews").child(Globals.userID).child("comments").setValue(comments)
        rootRef.child("bathroomsInfo").child(buildingID).child(bathroomNumber).child("reviews").child(Globals.userID).child("rating").setValue(userRating)
        rootRef.child("bathroomsInfo").child(buildingID).child(bathroomNumber).child("reviews").child(Globals.userID).child("title").setValue(title)
        rootRef.child("bathroomsInfo").child(buildingID).child(bathroomNumber).child("reviews").child(Globals.userID).child("date").setValue(dateFormatter.string(from: date))
        rootRef.child("bathroomsInfo").child(buildingID).child(bathroomNumber).child("reviews").child(Globals.userID).child("username").setValue(Globals.username)
        // update bathroom's rating
        rootRef.child("bathroomsInfo").child(buildingID).child(bathroomNumber).child("ratings").child(Globals.userID).setValue(userRating)
        
        print("middle")
        // update user's review
        rootRef.child("users").child(Globals.userID).child("reviews").child(buildingID + "_" + bathroomNumber).child("comments").setValue(comments)
        rootRef.child("users").child(Globals.userID).child("reviews").child(buildingID + "_" + bathroomNumber).child("rating").setValue(userRating)
        rootRef.child("users").child(Globals.userID).child("reviews").child(buildingID + "_" + bathroomNumber).child("title").setValue(title)
        rootRef.child("users").child(Globals.userID).child("reviews").child(buildingID + "_" + bathroomNumber).child("date").setValue(dateFormatter.string(from: date))
        // update user's rating
        rootRef.child("users").child(Globals.userID).child("ratings").child(buildingID + "_" + bathroomNumber).setValue(userRating)
        
//        And dismiss the whole view controller
        dismiss(animated: true, completion: nil)
        
    }// End send button pressed
}



// LEGACY CODE

//        Globals.store.pushReview(bathroomID: self.bathroomID, userID: String(Globals.userID), rating: String(self.userRating), title: title, comments: comments) {
//            (InsertionResult) in
//
//            switch InsertionResult {
//            case let .success(result):
//                print(result.resultString)
//            case let .failure(error):
//                print("Error pushing review: \(error)")
//                self.showToast(message: "Error sending review, try later", good: false)
//            }
//        }
