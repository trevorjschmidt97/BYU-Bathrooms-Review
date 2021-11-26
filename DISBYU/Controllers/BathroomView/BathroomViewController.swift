//
//  BathroomViewController.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/23/20.
//

import UIKit
import FirebaseDatabase

// CLASS FOR THE BATHROOM REVIEW SCREEN
class BathroomViewController: UIViewController {
    
    // DB References
    private let rootRef = Database.database().reference()
    private let bathroomsInfoRef = Database.database().reference().child("bathroomsInfo")
    
    @IBOutlet weak var buildingID_bathroomNumber_bathroomName_Label: UILabel!
    
    @IBOutlet weak var averageRatingLabel: UILabel!
    
    var progressViews: [UIProgressView] = []
    @IBOutlet weak var fiveStarProgressView: UIProgressView!
    @IBOutlet weak var fourStarProgressView: UIProgressView!
    @IBOutlet weak var threeStarProgressView: UIProgressView!
    @IBOutlet weak var twoStarProgressView: UIProgressView!
    @IBOutlet weak var oneStarProgressView: UIProgressView!
    
    @IBOutlet weak var numberOfRatingsLabel: UILabel!
    
    var starButtons: [UIButton] = []
    @IBOutlet weak var oneStarButton: UIButton!
    @IBOutlet weak var twoStarButton: UIButton!
    @IBOutlet weak var threeStarButton: UIButton!
    @IBOutlet weak var fourStarButton: UIButton!
    @IBOutlet weak var fiveStarButton: UIButton!
    
    @IBOutlet weak var writeReviewButton: UIButton!
    @IBOutlet weak var sortPicker: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var mapViewController: MapViewController!
    var buildingID: String!
    var bathroomNumber: String!
    var bathroomName: String!
    var dateFormatter: DateFormatter!
    
    var userRating: Int = 0
    var reviews = [fireReview]()
    var loading = true
    var sortingOptions = [["highestRating","Highest Upvotes"], ["lowestRating","Lowest Upvotes"]]//, ["newest","Newest Reviews"], ["oldest","Oldest Reviews"]]
    var currentSort = "highestRating"
    
    var avgRating: Float = 0.0
    var numRatings = 0
    var ratings = [0,0,0,0,0]
    
    var cameFromWrite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        sortPicker.delegate = self
        sortPicker.dataSource = self
    
        tableView.estimatedRowHeight = 150
        
        progressViews.append(oneStarProgressView)
        progressViews.append(twoStarProgressView)
        progressViews.append(threeStarProgressView)
        progressViews.append(fourStarProgressView)
        progressViews.append(fiveStarProgressView)
        
        starButtons.append(oneStarButton)
        starButtons.append(twoStarButton)
        starButtons.append(threeStarButton)
        starButtons.append(fourStarButton)
        starButtons.append(fiveStarButton)
        
        dateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }()
        
        // Start er up
        #if APPCLIP
            print("here")
        #else
            setupInfoOfBathroom() // need building ID and bathroom number
            currentSort = "highestRating"
            pullReviews()
        #endif
    }
    
    // Pulls all info at the top
    private func setupInfoOfBathroom() {
        bathroomsInfoRef.child(buildingID).child(bathroomNumber).observeSingleEvent(of: .value) { (snapshot) in
            // make sure we get a list of info from that bathroom
            if let infoDict = snapshot.value as? [String:Any] {
                
                // Get all info ready
                var bathroomName: String = ""
                var numReviews: Int = 0
                var avgRating: Float = 0.0
                var num5Reviews: Int = 0
                var num4Reviews: Int = 0
                var num3Reviews: Int = 0
                var num2Reviews: Int = 0
                var num1Reviews: Int = 0
                var userRating: Int = 0
                
                // for each piece of info from the db
                for key in infoDict.keys {
                    
                    if key == "name" {
                        bathroomName = infoDict[key] as! String
                    } else if key == "ratings" {
                        if let ratingsDict = infoDict[key]! as? [String:Any] {
                            var totalRating: Int = 0
                            for ratingKey in ratingsDict.keys {
                                numReviews += 1
                                totalRating += ratingsDict[ratingKey] as! Int
                                
                                if ratingsDict[ratingKey] as! Int == 5 {
                                    num5Reviews += 1
                                } else if ratingsDict[ratingKey] as! Int == 4 {
                                    num4Reviews += 1
                                } else if ratingsDict[ratingKey] as! Int == 3 {
                                    num3Reviews += 1
                                } else if ratingsDict[ratingKey] as! Int == 2 {
                                    num2Reviews += 1
                                } else if ratingsDict[ratingKey] as! Int == 1 {
                                    num1Reviews += 1
                                }
                                
                                if ratingKey == Globals.userID {
                                    userRating = ratingsDict[ratingKey] as! Int
                                }
                            }
                            avgRating = Float(Float(totalRating) / Float(numReviews))
                        }
                    }
                }
                
                let info = Info(buildingID: self.buildingID, bathroomName: bathroomName, bathroomNumber: self.bathroomNumber, numReviews: numReviews, avgRating: avgRating, num5Reviews: num5Reviews, num4Reviews: num4Reviews, num3Reviews: num3Reviews, num2Reviews: num2Reviews, num1Reviews: num1Reviews, userRating: userRating)
                
                // Pull info
                self.avgRating = info.avgRating
                self.numRatings = info.numReviews
                self.userRating = info.userRating
                self.ratings[4] = info.num5Reviews
                self.ratings[3] = info.num4Reviews
                self.ratings[2] = info.num3Reviews
                self.ratings[1] = info.num2Reviews
                self.ratings[0] = info.num1Reviews
                
                // Set labels
                self.buildingID_bathroomNumber_bathroomName_Label.text = info.buildingID + " - " + String(info.bathroomNumber) + " - " + info.bathroomName
                self.averageRatingLabel.text = String(format: "%.1f", self.avgRating)
                if self.numRatings == 1 {
                    self.numberOfRatingsLabel.text = String(self.numRatings) + " Rating"
                } else {
                    self.numberOfRatingsLabel.text = String(self.numRatings) + " Ratings"
                }
                
                // Set progress views and star buttons
                for i in 0...4 {
                    if self.numRatings != 0 {
                        self.progressViews[i].setProgress(Float(self.ratings[i]) / Float(self.numRatings), animated: true)
                    } else {
                        self.progressViews[i].setProgress(0.0, animated: true)
                    }
                    
                    if self.userRating > i {
                        self.starButtons[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
                    } else {
                        self.starButtons[i].setImage(UIImage(systemName: "star"), for: .normal)
                    }
                }
                
            }
        }
    }
    
    // Pulls reviews, may be called to resort the reviews
    private func pullReviews() {
        bathroomsInfoRef.child(buildingID).child(bathroomNumber).child("reviews").observe(.value) { (snapshot) in
           
            if let reviewsDict = snapshot.value as? [String:Any] {
                self.loading = false
                self.reviews = [fireReview]()
                
                // For each review
                for reviewKey in reviewsDict.keys {
                    // Create a review
                    let userID: String = reviewKey
                    var username: String = ""
                    var title: String = ""
                    var comments: String = ""
                    var date: String = ""
                    var rating: Int = 0
                    var upvotes: Int = 0
                    var userLike: Int = 0

                    // Grab the review's info
                    if let singleReviewDict = reviewsDict[reviewKey] as? [String:Any] {
                        
                        // for each piece of info
                        for attributeKey in singleReviewDict.keys {
                            if attributeKey == "title" {
                                title = singleReviewDict[attributeKey] as! String
                            } else if attributeKey == "comments" {
                                comments = singleReviewDict[attributeKey] as! String
                            } else if attributeKey == "rating" {
                                rating = singleReviewDict[attributeKey] as! Int
                            } else if attributeKey == "date" {
                                date = singleReviewDict[attributeKey] as! String
                            } else if attributeKey == "username" {
                                username = singleReviewDict[attributeKey] as! String
                            } else if attributeKey == "upvotes" {
                                
                                // Grab the dict of userID's -> upvote
                                if let upvotesDict = singleReviewDict[attributeKey] as? [String:Int] {
                                    
                                    // for each one
                                    for upvoteKey in upvotesDict.keys {
                                        if upvoteKey == Globals.userID {
                                            userLike = upvotesDict[upvoteKey]!
                                        }
                                        upvotes += upvotesDict[upvoteKey]!
                                    }
                                }
                            }
                        }
                    }
                    // Create the review
                    let review = fireReview(userID: userID, username: username, title: title, comments: comments, date: date, rating: rating, upvotes: upvotes, userLike: userLike)
                    
                    // And add it to the list
                    self.reviews.append(review)
                }
                
                // Then sort the reviews, based on whatever sort
                if self.currentSort == "highestRating" {
                    self.reviews.sort(by: {$0.upvotes > $1.upvotes})
                } else if self.currentSort == "lowestRating" {
                    self.reviews.sort(by: {$0.upvotes < $1.upvotes})
                } else if self.currentSort == "newest" {
                    self.reviews.sort(by: {$0.date < $1.date})
                } else if self.currentSort == "oldest" {
                    self.reviews.sort(by: {$0.date > $1.date})
                }
                
                // And relaod the tableView
                self.tableView.reloadData()
            }  // End checks of info returned
        } // End call to db
    } // end func to update reviews
    
    
    // All Tap to Rate button actions
    @IBAction func oneStarPressed(_ sender: Any) {
        starPressed(rating: 1)
    }
    @IBAction func twoStarPressed(_ sender: Any) {
        starPressed(rating: 2)
    }
    @IBAction func threeStarPressed(_ sender: Any) {
        starPressed(rating: 3)
    }
    @IBAction func fourStarPressed(_ sender: Any) {
        starPressed(rating: 4)
    }
    @IBAction func fiveStarPressed(_ sender: Any) {
        starPressed(rating: 5)
    }
    // Helper function for star presses
    private func starPressed(rating: Int) {
        // If not logged in, present alert
        if Globals.userID == "0" {
            let alert = UIAlertController(title: "You Must Sign In To Rate This Bathroom", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Log In / Register", style: UIAlertAction.Style.default) {
              UIAlertAction in
                self.performSegue(withIdentifier: "loginFromBathroom", sender: self)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let oldRating = userRating // grabs old rating
        self.userRating = rating // and updates it
        
        // updates stars
        for i in 0...4 {
            if self.userRating > i {
                self.starButtons[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                self.starButtons[i].setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        
        // Initiate adding of the rating to the db
        bathroomsInfoRef.child(buildingID).child(bathroomNumber).child("ratings").observeSingleEvent(of: .value) { (snapshot) in
            
            // Add that rating to the info
            self.ratings[rating - 1] += 1
            
            // If a rating was already here, ie.. was updated
            if snapshot.hasChild(Globals.userID) {
                switch oldRating {
                case 1:
                    self.ratings[0] -= 1
                case 2:
                    self.ratings[1] -= 1
                case 3:
                    self.ratings[2] -= 1
                case 4:
                    self.ratings[3] -= 1
                case 5:
                    self.ratings[4] -= 1
                default:
                    print("error in that the old rating was not a number")
                }
                
            // if not, increment the numRatings
            } else {
                self.numRatings += 1
            }
            
            // Update the db
                // in the bathroomsInfo
            self.bathroomsInfoRef.child(self.buildingID).child(self.bathroomNumber).child("ratings").child(Globals.userID).setValue(rating)
            self.bathroomsInfoRef.child(self.buildingID).child(self.bathroomNumber).child("reviews").observeSingleEvent(of: .value) { (snapshott) in
                if snapshott.hasChild(Globals.userID) {
                    self.bathroomsInfoRef.child(self.buildingID).child(self.bathroomNumber).child("reviews").child(Globals.userID).child("rating").setValue(rating)
                }
            }
                // and user
            self.rootRef.child("users").child(Globals.userID).child("ratings").child(self.buildingID + "_" + self.bathroomNumber).setValue(rating)
            self.rootRef.child("users").child(Globals.userID).child("reviews").observeSingleEvent(of: .value) { (snapshott) in
                if snapshott.hasChild(self.buildingID + "_" + self.bathroomNumber) {
                    self.rootRef.child("users").child(Globals.userID).child("reviews").child(self.buildingID + "_" + self.bathroomNumber).child("rating").setValue(rating)
                }
            }
            
            // Reset avg's and numRatings
            let totalRating = self.ratings[0] + (2 * self.ratings[1]) + (3 * self.ratings[2]) + (4 * self.ratings[3]) + (5 * self.ratings[4])
            self.avgRating = Float(totalRating) / Float(self.numRatings)
            
            // Update avg's and numRatings
            if self.numRatings == 1 {
                self.numberOfRatingsLabel.text = String(self.numRatings) + " Rating"
            } else {
                self.numberOfRatingsLabel.text = String(self.numRatings) + " Ratings"
            }
            self.averageRatingLabel.text = String(format: "%.1f", self.avgRating)
            
            // Update progress views
            for i in 0...4 {
                self.progressViews[i].setProgress(Float(self.ratings[i]) / Float(self.numRatings), animated: true)
            }
            
        } // End call to db

    } // End of star pressed
    
     
    // Segue switch to go into reviewViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        // Get info ready for reviewViewController
        case "showReview":
            let reviewViewController = segue.destination as! ReviewViewController
            reviewViewController.userRating = userRating
            reviewViewController.bathroomID = bathroomName
            reviewViewController.buildingID = buildingID
            reviewViewController.bathroomNumber = bathroomNumber
        case "loginFromBathroom":
            print("prepare for loginFromBathroom")
        case "showUser":
            print("prepare for showUser")
            if let row = tableView.indexPathForSelectedRow?.row {
                let userViewController = segue.destination as! UserViewController
                userViewController.username = reviews[row].username
                userViewController.userID = reviews[row].userID
                userViewController.isUser = false
            }
        default:
            preconditionFailure("Unexpected segue identifier in bathroomViewController.")
        }
    }
    
    // Make sure you're signed in to write a review
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "showReview":
            if Globals.userID == "0" {
                let alert = UIAlertController(title: "You Must Sign In To Review This Bathroom", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Log In / Register", style: UIAlertAction.Style.default) {
                  UIAlertAction in
                    self.performSegue(withIdentifier: "loginFromBathroom", sender: self)
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
        case "showUser":
            print("check")
        default:
            preconditionFailure("Unexpected segue identifier in bathroomViewController.")
        }
        return true
    }
    
} // End of BathroomViewController

// Table View Delegates
extension BathroomViewController: UITableViewDelegate {
    // Deselect a cell from the tableview when selected, boring
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

// Table View Delegate
extension BathroomViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 0
        } else {
            return reviews.count
        }
    }
    
    // Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        
        // empty cell until reviews are pulled in
        if loading { return cell }
        
        // Title
        cell.titleLabel.text = reviews[indexPath.row].title.decode()
        
        // Date
        cell.dateLabel.text = reviews[indexPath.row].date//""//dateFormatter.string(from: reviews[indexPath.row].date)
        
        // User
        cell.userLabel.text = reviews[indexPath.row].username.decode()
        
        // Rating
        cell.ratingCosmosView.settings.fillMode = .precise
        cell.ratingCosmosView.rating = Double(reviews[indexPath.row].rating)
        
        // Comments
        var comments = reviews[indexPath.row].comments.decode()
        comments = comments.replacingOccurrences(of: "\\n", with: "\n")
        cell.commentsLabel.text = comments
        
        // Upvotes
        cell.upvotesLabel.text = String(reviews[indexPath.row].upvotes)
        
        // Buttons // Set to normal
        cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        cell.dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
        // Then change to filled if necessary
        if reviews[indexPath.row].userLike > 0 {
            cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        }
        if reviews[indexPath.row].userLike < 0 {
            cell.dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
        }
        
        // Meta data, ratingID and userID - used for when the like/dislike button is pressed
        cell.buildingID = buildingID
        cell.bathroomNumber = bathroomNumber
        cell.username = reviews[indexPath.row].username
        cell.userID = reviews[indexPath.row].userID
        
        return cell
    }
}

// PickerView Delegate
extension BathroomViewController: UIPickerViewDelegate {
    // Selection of a picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSort = sortingOptions[row][0]
        pullReviews()
    }
}
extension BathroomViewController: UIPickerViewDataSource {
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




// LEGACY CODE

//        Globals.store.fetchInfoOfBathroom(bathroomID: bathroomName, userID: String(Globals.userID)) {
//            (infoResult) in
//
//            switch infoResult {
//            case let .success(info):
//                // Pull info
//                self.avgRating = info.avgRating
//                self.numRatings = info.numReviews
//                self.userRating = info.userRating
//                self.ratings[4] = info.num5Reviews
//                self.ratings[3] = info.num4Reviews
//                self.ratings[2] = info.num3Reviews
//                self.ratings[1] = info.num2Reviews
//                self.ratings[0] = info.num1Reviews
//
//                // Set labels
//                self.buildingID_bathroomNumber_bathroomName_Label.text = info.buildingID + " - " + String(info.bathroomNumber) + " - " + info.bathroomName
//                self.averageRatingLabel.text = String(format: "%.1f", self.avgRating)
//                if self.numRatings == 1 {
//                    self.numberOfRatingsLabel.text = String(self.numRatings) + " Rating"
//                } else {
//                    self.numberOfRatingsLabel.text = String(self.numRatings) + " Ratings"
//                }
//
//                // Set progress views and star buttons
//                for i in 0...4 {
//                    if self.numRatings != 0 {
//                        self.progressViews[i].setProgress(Float(self.ratings[i]) / Float(self.numRatings), animated: true)
//                    } else {
//                        self.progressViews[i].setProgress(0.0, animated: true)
//                    }
//                    if self.userRating > i {
//                        self.starButtons[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
//                    } else {
//                        self.starButtons[i].setImage(UIImage(systemName: "star"), for: .normal)
//                    }
//                }
//
//            case let .failure(error):
//                print("Error fetching info of bathroom: \(error)")
//                self.showToast(message: "Error fetching info, try later", good: false)
//            }
//        }

//        Globals.store.fetchReviewsInBathroom(bathroomID: bathroomID, sort: sort, userID: Globals.userID) {
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
//                self.showToast(message: "Error fetching info, try later", good: false)
//            }
//        }


//        Globals.store.pushRating(bathroomID: bathroomName, userID: String(Globals.userID), rating: String(rating)) {
//            (insertionResult) in
//
//            switch insertionResult {
//            case let .success(result):
//                // add to the rating array
//                self.ratings[rating - 1] += 1
//
//                // if inserted, thats one more rating
//                if result.resultString == "Rating inserted" {
//                    self.numRatings += 1
//
//                    // if it was updated, then take 1 away from old rating
//                } else if result.resultString == "Rating updated" {
//                    switch oldRating {
//                    case 1:
//                        self.ratings[0] -= 1
//                    case 2:
//                        self.ratings[1] -= 1
//                    case 3:
//                        self.ratings[2] -= 1
//                    case 4:
//                        self.ratings[3] -= 1
//                    case 5:
//                        self.ratings[4] -= 1
//                    default:
//                        print("error in that the old rating was not a number")
//                    }
//                }
//
//                // Reset avg's and numRatings
//                let totalRating = self.ratings[0] + (2 * self.ratings[1]) + (3 * self.ratings[2]) + (4 * self.ratings[3]) + (5 * self.ratings[4])
//                self.avgRating = Float(totalRating) / Float(self.numRatings)
//
//                // Update avg's and numRatings
//                if self.numRatings == 1 {
//                    self.numberOfRatingsLabel.text = String(self.numRatings) + " Rating"
//                } else {
//                    self.numberOfRatingsLabel.text = String(self.numRatings) + " Ratings"
//                }
//                self.averageRatingLabel.text = String(format: "%.1f", self.avgRating)
//
//                // Update progress views
//                for i in 0...4 {
//                    self.progressViews[i].setProgress(Float(self.ratings[i]) / Float(self.numRatings), animated: true)
//                }
//            case let .failure(error):
//                print("Error pushing rating: \(error)")
//                self.showToast(message: "Error submitting rating, try later", good: false)
//            }
//        }
