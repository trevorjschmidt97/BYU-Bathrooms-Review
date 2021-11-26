//
//  ViewController.swift
//  SpecificBathroomAppClip
//
//  Created by Trevor Schmidt on 4/20/21.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    @IBOutlet weak var ratingsAndReviewsLabel: UILabel!
    @IBOutlet weak var buildingID_bathroomNumber_bathroomName_Label: UILabel!
    
    @IBOutlet weak var averageRatingLabel: UILabel!
    
    @IBOutlet weak var fiveStarProgressView: UIProgressView!
    @IBOutlet weak var fourStarProgressView: UIProgressView!
    @IBOutlet weak var threeStarProgressView: UIProgressView!
    @IBOutlet weak var twoStarProgressView: UIProgressView!
    @IBOutlet weak var oneStarProgressView: UIProgressView!
    var progressViews: [UIProgressView] = []
    
    @IBOutlet weak var numberOfRatingsLabel: UILabel!
    
    @IBOutlet weak var writeReviewButton: UIButton!
    
    @IBOutlet weak var sortPicker: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dateFormatter: DateFormatter!
    var loading = true
    var reviews = [IndividualBathroomReview]()
    var sortingOptions = [["highestRating","Highest Upvotes"], ["lowestRating","Lowest Upvotes"]]
    var currentSort = "highestRating"
    let baseURLString = "https://doesitstink-default-rtdb.firebaseio.com/bathroomsInfo/"
    let jsonString = ".json"
    let prettyPrinting = "?print=pretty"
    
    var buildingID: String = ""
    var bathroomNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sortPicker.delegate = self
        sortPicker.dataSource = self
        
        progressViews.append(oneStarProgressView)
        progressViews.append(twoStarProgressView)
        progressViews.append(threeStarProgressView)
        progressViews.append(fourStarProgressView)
        progressViews.append(fiveStarProgressView)
        
        dateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }()
        
        pullInfoOfBathroom()
    }
    
     //TODO: Pull all bathroom Info
    private func pullInfoOfBathroom() {
        print("\nIn pull info of bathroom")
        print("\tbuildingID", buildingID)
        print("\tbathroomNumber", bathroomNumber)

        var bathroomData = [String: Any]()
        let url = URL(string: baseURLString + buildingID + "/" + bathroomNumber + jsonString + prettyPrinting)
        print(url!)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {return}
            do {
                bathroomData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            } catch let error as NSError {
                print(error)
            }
            
            var bathroomName: String = ""
            var numRatings: Int = 0
            var ratings: [Int] = [0,0,0,0,0]
            var avgRating: Double = 0.0
            var reviewsList: [IndividualBathroomReview] = [IndividualBathroomReview]()
            
            for key in bathroomData.keys {
                if key == "name" {
                    // Grab the name of the bathroom from the data
                    print("bathroomName:", bathroomData[key]!)
                    bathroomName = bathroomData[key] as! String
                    
                } else if key == "ratings" {
                    // Grab all the ratings info from the data
                    let ratingDict = bathroomData["ratings"] as! [String:Int]
                    var totalRatings: Int = 0
                    for ratingKey in ratingDict.keys {
                        numRatings += 1
                        totalRatings += ratingDict[ratingKey]!
                        if ratingDict[ratingKey]! == 1 {
                            ratings[0] += 1
                        } else if ratingDict[ratingKey]! == 2 {
                            ratings[1] += 1
                        } else if ratingDict[ratingKey]! == 3 {
                            ratings[2] += 1
                        } else if ratingDict[ratingKey]! == 4 {
                            ratings[3] += 1
                        } else if ratingDict[ratingKey]! == 5 {
                            ratings[4] += 1
                        }
                    }
                    avgRating = Double(totalRatings) / Double(numRatings)
                    
                } else if key == "reviews" {
                    // Grab all the reviews info from the data
                    let reviewsDict = bathroomData["reviews"] as! [String: Any]
                    for reviewKey in reviewsDict.keys {
                        var username: String = ""
                        var title: String = ""
                        var comments: String = ""
                        var date: String = ""
                        var rating: Int = 0
                        var upvotes: Int = 0
                        
                        let reviewInfoDict = reviewsDict[reviewKey] as! [String: Any]
                        for infoKey in reviewInfoDict.keys {
                            if infoKey == "username" {
                                username = reviewInfoDict[infoKey] as! String
                            } else if infoKey == "title" {
                                title = reviewInfoDict[infoKey] as! String
                            } else if infoKey == "date" {
                                date = reviewInfoDict[infoKey] as! String
                            } else if infoKey == "comments" {
                                comments = reviewInfoDict[infoKey] as! String
                            } else if infoKey == "rating" {
                                rating = reviewInfoDict[infoKey] as! Int
                            } else if infoKey == "upvotes" {
                                let upvotesDict = reviewInfoDict[infoKey] as! [String: Int]
                                for upvotesKey in upvotesDict.keys {
                                    upvotes += upvotesDict[upvotesKey]!
                                }
                            }
                        }
                        
                        let newReview = IndividualBathroomReview(username: username, title: title, comments: comments, date: date, rating: rating, upvotes: upvotes)
                        
                        reviewsList.append(newReview)
                    }
                    
                }
            }
            
            
            self.loading = false
            
            DispatchQueue.main.async {
                self.buildingID_bathroomNumber_bathroomName_Label.text = self.buildingID + " - " + self.bathroomNumber + " - " + bathroomName
                self.numberOfRatingsLabel.text = String(numRatings) + " Ratings"
                self.averageRatingLabel.text = String(format: "%.1f", avgRating)
                
                for i in 0...4 {
                    self.progressViews[i].setProgress(Float(ratings[i]) / Float(numRatings), animated: true)
                }
                
                reviewsList.sort(by: {$0.upvotes > $1.upvotes})
                self.reviews = reviewsList
                
                self.tableView.reloadData()
            }
        }).resume()
     
    }

    // TODO: Send user to app store
    @IBAction func rateReviewButtonPressed(_ sender: Any) {
        guard let scene = view.window?.windowScene else { return }

        let config = SKOverlay.AppClipConfiguration(position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.present(in: scene)
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 0
        } else {
            if reviews.count == 0 {
                return 1
            }
            return reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppClipCell", for: indexPath) as! IndividualBathroomReviewCell
        
        // empty cell until reviews are pulled in
        if loading { return cell }
        
        if reviews.count == 0 {
            cell.titleLabel.text = "This bathroom has no reviews"
            cell.dateLabel.text = ""
            cell.userLabel.text = ""
            cell.ratingCosmosView.settings.fillMode = .precise
            cell.ratingCosmosView.rating = Double(0)
            cell.upvotesLabel.text = "-"
            cell.commentsLabel.text = "Be the first to write a review by hitting the link above."
            return cell
        }
        
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
        
        return cell
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentSort != sortingOptions[row][0] {
            reviews.reverse()
            tableView.reloadData()
        }
        currentSort = sortingOptions[row][0]
        // add in method to reverse reviews
    }
}
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortingOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingOptions[row][1]
    }
}

extension String {
  func decode() -> String {
      let data = self.data(using: .utf8)!
      return String(data: data, encoding: .nonLossyASCII) ?? self
  }

  func encode() -> String {
      let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
      return String(data: data, encoding: .utf8)!
  }
}
