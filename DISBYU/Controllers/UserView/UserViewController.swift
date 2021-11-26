//
//  UserViewController.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/27/20.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserViewController: UIViewController {

    // User Info
    var userID: String? = nil//Globals.userID
    var username: String? = nil
    var isUser: Bool = false
    
    // Labels and such
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avgRatingLabel: UILabel!
    
    @IBOutlet weak var fiveStarProgressView: UIProgressView!
    @IBOutlet weak var fourStarProgressView: UIProgressView!
    @IBOutlet weak var threeStarProgressView: UIProgressView!
    @IBOutlet weak var twoStarProgressView: UIProgressView!
    @IBOutlet weak var oneStarProgressView: UIProgressView!
    
    @IBOutlet weak var reviewScoreLabel: UILabel!
    @IBOutlet weak var numRatingsLabel: UILabel!
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var clickHereButton: UIButton!
    
    var dateFormatter: DateFormatter!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewPickerView: UIPickerView!
    
    // Other info
    var reviews = [UserReview]()
    var sortingOptions = [["highestRating","Highest Upvotes"], ["lowestRating","Lowest Upvotes"]]//, ["newest","Newest Reviews"], ["oldest","Oldest Reviews"]]
    var currentSort = "highestRating"
    var loading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 150
        
        reviewPickerView.delegate = self
        reviewPickerView.dataSource = self
        
        if Globals.userID == "0" {
            signOutButton.isHidden = true
        }
        
        if !isUser {
            signOutButton.isHidden = true
        }
        
        usernameLabel.text = ""
        avgRatingLabel.text = "0.0"
        reviewScoreLabel.text = "Review Score: " + String(0)
        
        fiveStarProgressView.progress = Float(0.0)
        fourStarProgressView.progress = Float(0.0)
        threeStarProgressView.progress = Float(0.0)
        twoStarProgressView.progress = Float(0.0)
        oneStarProgressView.progress = Float(0.0)
        
        dateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }()
        
        // Run the program
        setupInfoOfUser()
        pullUserReviews(userID: userID!, sort: "highestRating")
    }
    
    // Pulls all info at the top
    private func setupInfoOfUser() {
        let rootRef = Database.database().reference()
        
        rootRef.child("users").child(userID!).observe(.value) { (snapshot) in
//        rootRef.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDict = snapshot.value as? [String:Any] else { return }
            
            var username: String = ""
            var numRatings: Int = 0
            var avgRating: Float = 0.0
            var num5Reviews = 0
            var num4Reviews = 0
            var num3Reviews = 0
            var num2Reviews = 0
            var num1Reviews = 0
            var reviewScore = 0
            
            for userKey in userDict.keys {
                if userKey == "username" {
                    username = userDict[userKey] as! String
                } else if userKey == "ratings" {
                    if let ratingsDict = userDict[userKey] as? [String:Int] {
                        var totalRate = 0
                        for ratingKey in ratingsDict.keys {
                            numRatings += 1
                            totalRate += ratingsDict[ratingKey]!
                            if ratingsDict[ratingKey] == 5 {
                                num5Reviews += 1
                            } else if ratingsDict[ratingKey] == 4 {
                                num4Reviews += 1
                            } else if ratingsDict[ratingKey] == 3 {
                                num3Reviews += 1
                            } else if ratingsDict[ratingKey] == 2 {
                                num2Reviews += 1
                            } else if ratingsDict[ratingKey] == 1 {
                                num1Reviews += 1
                            }
                        }
                        avgRating = Float(Float(totalRate) / Float(numRatings))
                    }
                } else if userKey == "reviews" {
                    if let reviewsDict = userDict["reviews"] as? [String:Any] {
                        for bathroomNameKey in reviewsDict.keys {
                            if let reviewInfoDict = reviewsDict[bathroomNameKey] as? [String:Any] {
                                if let upvotesDict = reviewInfoDict["upvotes"] as? [String:Int] {
                                    for upvote in upvotesDict.keys {
                                        reviewScore += upvotesDict[upvote]!
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            let info = UserInfo(username: username, numRatings: numRatings, avgRating: avgRating, num5Reviews: num5Reviews, num4Reviews: num4Reviews, num3Reviews: num3Reviews, num2Reviews: num2Reviews, num1Reviews: num1Reviews, reviewScore: reviewScore)
            
            self.usernameLabel.text = info.username
            
            self.avgRatingLabel.text = String(format: "%.1f", info.avgRating)
            
            if info.numRatings == 0 {
                self.fiveStarProgressView.setProgress( 0.0 , animated: true)
                self.fourStarProgressView.setProgress( 0.0 , animated: true)
                self.threeStarProgressView.setProgress( 0.0 , animated: true)
                self.twoStarProgressView.setProgress( 0.0 , animated: true)
                self.oneStarProgressView.setProgress( 0.0 , animated: true)
            } else {
                self.fiveStarProgressView.setProgress( Float(info.num5Reviews) / Float(info.numRatings) , animated: true)
                self.fourStarProgressView.setProgress( Float(info.num4Reviews) / Float(info.numRatings) , animated: true)
                self.threeStarProgressView.setProgress( Float(info.num3Reviews) / Float(info.numRatings) , animated: true)
                self.twoStarProgressView.setProgress( Float(info.num2Reviews) / Float(info.numRatings) , animated: true)
                self.oneStarProgressView.setProgress( Float(info.num1Reviews) / Float(info.numRatings) , animated: true)
            }
            
            if info.numRatings == 1 {
                self.numRatingsLabel.text = String(info.numRatings) + " Rating Given"
            } else {
                self.numRatingsLabel.text = String(info.numRatings) + " Ratings Given"
            }
            
            self.reviewScoreLabel.text = "Upvote Score: " + String(info.reviewScore)
        }
    }
    
    // Pulls reviews, may be called to resort the reviews
    private func pullUserReviews(userID: String, sort: String) {
        let rootRef = Database.database().reference()
        
        
        
        rootRef.child("users").child(userID).child("reviews").observe(.value) { (snapshot) in
//        rootRef.child("users").child(userID).child("reviews").observeSingleEvent(of: .value) { (snapshot) in
            guard let reviewsDict = snapshot.value as? [String: Any] else { return }
            self.reviews = [UserReview]()
            
            for reviewKey in reviewsDict.keys {
                var title: String = ""
                var comments: String = ""
                var date: String = ""
                var rating: Int = 0
                var bathroomID: String = ""
                var upvotes: Int = 0
                
                bathroomID = reviewKey
                
                if let reviewInfoDict = reviewsDict[reviewKey] as? [String: Any] {
                    
                    for infoKey in reviewInfoDict.keys {
                        if infoKey == "title" {
                            title = reviewInfoDict[infoKey] as! String
                        } else if infoKey == "comments" {
                            comments = reviewInfoDict[infoKey] as! String
                        } else if infoKey == "date" {
                            date = reviewInfoDict[infoKey] as! String
                        } else if infoKey == "rating" {
                            rating = reviewInfoDict[infoKey] as! Int
                        } else if infoKey == "upvotes" {
                            if let upvotesDict = reviewInfoDict[infoKey] as? [String: Int] {
                                for upvoteKey in upvotesDict.keys {
                                    upvotes += upvotesDict[upvoteKey]!
                                }
                            }
                        }
                    }
                }
                
                let review = UserReview(title: title, comments: comments, date: date, rating: rating, bathroomID: bathroomID, upvotes: upvotes)
                
                self.reviews.append(review)
            }
            if self.currentSort == "highestRating" {
                self.reviews.sort(by: {$0.upvotes > $1.upvotes})
            } else if self.currentSort == "lowestRating" {
                self.reviews.sort(by: {$0.upvotes < $1.upvotes})
            } else if self.currentSort == "newest" {
                self.reviews.sort(by: {$0.date < $1.date})
            } else if self.currentSort == "oldest" {
                self.reviews.sort(by: {$0.date > $1.date})
            }
            
            self.loading = false
            self.tableView.reloadData()
            
//            self.reviews = [UserReview]()
        }
        
        
//        Globals.store.fetchReviewsOfUser(userID: userID, sort: sort) {
//            (reviewsResult) in
//            switch reviewsResult {
//            // successful pull of reviews
//            case let .success(reviews):
//                self.loading = false
//                self.reviews = reviews
//                self.tableView.reloadData()
//            // Error in pulling reviews
//            case let .failure(error):
//                print("Error fetching info of bathroom: \(error)")
//                self.showToast(message: "Error fetching info", good: false)
//            }
//        }
    }
    
    @IBAction func clickHereButtonPressed(_ sender: Any) {
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            Globals.userID = "0"
            let alert = UIAlertController(title: "You have successfully signed out", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default) {
              UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true, completion: nil)
        } catch {
            showToast(message: "There has been an error in signing out", good: false)
        }
    }
}

// TableView Extensions
extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 0
        } else {
            return reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if loading {
            return "Reviews:"
        }
        guard let username = self.username else {
            return "Reviews:"
        }
        return username + "'s reviews:"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewCell", for: indexPath) as! UserReviewCell
        if loading {
            cell.titleLabel.text = ""
            cell.dateLabel.text = ""
            cell.bathroomLable.text = ""
            cell.ratingCosmosView.settings.fillMode = .precise
            cell.ratingCosmosView.rating = 0
            cell.commentsLabel.text = ""
            cell.upvotesLabel.text = ""
            return cell
        }
        cell.titleLabel.text = reviews[indexPath.row].title.decode()
        cell.commentsLabel.text = reviews[indexPath.row].comments.decode()
        cell.bathroomLable.text = reviews[indexPath.row].bathroomID
        cell.dateLabel.text = reviews[indexPath.row].date// dateFormatter.string(from: reviews[indexPath.row].date)
        cell.upvotesLabel.text = String(reviews[indexPath.row].upvotes)
        cell.ratingCosmosView.settings.fillMode = .precise
        cell.ratingCosmosView.rating = Double(reviews[indexPath.row].rating)
        
        return cell
    }
}

extension UserViewController: UIPickerViewDelegate {
    // Selection of a picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentSort = sortingOptions[row][0]
        pullUserReviews(userID: userID!, sort: sortingOptions[row][0])
    }
}
extension UserViewController: UIPickerViewDataSource {
    // How many columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // How many rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortingOptions.count
    }
    // Title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingOptions[row][1]
    }
}



//        Globals.store.fetchInfoOfUser(userID: userID) {
//            (infoResult) in
//
//            switch infoResult {
//            case let .success(info):
//                self.usernameLabel.text = info.username
//
//                self.avgRatingLabel.text = String(format: "%.1f", info.avgRating)
//
//                if info.numRatings == 0 {
//                    self.fiveStarProgressView.setProgress( 0.0 , animated: true)
//                    self.fourStarProgressView.setProgress( 0.0 , animated: true)
//                    self.threeStarProgressView.setProgress( 0.0 , animated: true)
//                    self.twoStarProgressView.setProgress( 0.0 , animated: true)
//                    self.oneStarProgressView.setProgress( 0.0 , animated: true)
//                } else {
//                    self.fiveStarProgressView.setProgress( Float(info.num5Reviews) / Float(info.numRatings) , animated: true)
//                    self.fourStarProgressView.setProgress( Float(info.num4Reviews) / Float(info.numRatings) , animated: true)
//                    self.threeStarProgressView.setProgress( Float(info.num3Reviews) / Float(info.numRatings) , animated: true)
//                    self.twoStarProgressView.setProgress( Float(info.num2Reviews) / Float(info.numRatings) , animated: true)
//                    self.oneStarProgressView.setProgress( Float(info.num1Reviews) / Float(info.numRatings) , animated: true)
//                }
//
//                if info.numRatings == 1 {
//                    self.numRatingsLabel.text = String(info.numRatings) + " Rating"
//                } else {
//                    self.numRatingsLabel.text = String(info.numRatings) + " Ratings"
//                }
//
//                self.reviewScoreLabel.text = "Review Score: " + String(info.reviewScore)
//
//            case let .failure(error):
//                print("Error fetching info of user: \(error)")
//                self.showToast(message: "Error fetching info", good: false)
//            }
//        }
