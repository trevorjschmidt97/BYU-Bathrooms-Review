////
////  LeaderBoardViewController.swift
////  DISBYU
////
////  Created by Trevor Schmidt on 11/26/20.
////
//
//import UIKit
//
//class LeaderBoardViewController: UIViewController {
//    
//    var leaders: [Leader] = []
//    var loading: Bool = true
//    
//    @IBOutlet weak var todayButton: UIButton!
//    @IBOutlet var weekButton: UIButton!
//    @IBOutlet var monthButton: UIButton!
//    @IBOutlet var allTimeButton: UIButton!
//    
//    @IBOutlet var tableView: UITableView!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        pullLeaders(time: "day")
//    }
//    
//    private func pullLeaders(time: String) {
//        Globals.store.fetchLeaders(time: time) {
//            (leadersResult) in
//            
//            switch leadersResult {
//            case let .success(leaders):
//                self.leaders = leaders
//                self.loading = false
//                self.tableView.reloadData()
//            case let .failure(error):
//                print("Error fetching leaders: \(error)")
//            }
//        }
//    }
//    
//    
//    @IBAction func todayButtonPressed(_ sender: Any) {
//        todayButton.isSelected = true
//        weekButton.isSelected = false
//        monthButton.isSelected = false
//        allTimeButton.isSelected = false
//        
//        pullLeaders(time: "day")
//    }
//    @IBAction func weekButtonPressed(_ sender: Any) {
//        todayButton.isSelected = false
//        weekButton.isSelected = true
//        monthButton.isSelected = false
//        allTimeButton.isSelected = false
//        
//        pullLeaders(time: "week")
//    }
//    @IBAction func monthButtonPressed(_ sender: Any) {
//        todayButton.isSelected = false
//        weekButton.isSelected = false
//        monthButton.isSelected = true
//        allTimeButton.isSelected = false
//        
//        pullLeaders(time: "month")
//    }
//    @IBAction func allTimeButtonPressed(_ sender: Any) {
//        todayButton.isSelected = false
//        weekButton.isSelected = false
//        monthButton.isSelected = false
//        allTimeButton.isSelected = true
//        
//        pullLeaders(time: "allTime")
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "showLeaderUser":
//            print("Preparing segue from leaderboards")
////            if let row = tableView.indexPathForSelectedRow?.row {
////                let userViewController = segue.destination as! UserViewController
////            }
//        default:
//            print("default")//preconditionFailure("Unexpected segue identifier.")
//        }
//    }
//    
//}
//
//extension LeaderBoardViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You tapped me!")
//        self.tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
//extension LeaderBoardViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Usernames and review scores:"
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if loading {
//            return 1
//        } else {
//            return leaders.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        if loading {
//            cell.textLabel?.text = "Hello"
//        } else {
//            cell.textLabel?.text = String(indexPath.row + 1) + ": " +  leaders[indexPath.row].username
//            cell.detailTextLabel?.text = String(leaders[indexPath.row].upvotes)
//            
//            if leaders[indexPath.row].username == "Currently no reviews for this time period" {
//                cell.isHighlighted = true
//            }
//        }
//        
//        return cell
//    }
//    
//    
//}
