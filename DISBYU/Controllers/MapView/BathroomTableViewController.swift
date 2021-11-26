//
//  BathroomTableViewController.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 12/18/20.
//

import UIKit

class BathroomTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var bathroomsArray = [[Bathroom]]()
    var currentBuildingID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 10
    }
    
    // Called when a bathroom is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showBathroom":
            if let row = tableView.indexPathForSelectedRow?.row {
                if let section = tableView.indexPathForSelectedRow?.section {
                    // Set all necessary info for this segue
                    let bathroomViewController = segue.destination as! BathroomViewController
                    
                    let bathroomName = bathroomsArray[section][row].buildingID.lowercased() + bathroomsArray[section][row].bathroomNumber
                    bathroomViewController.bathroomName = bathroomName
                    bathroomViewController.buildingID = bathroomsArray[section][row].buildingID
                    bathroomViewController.bathroomNumber = bathroomsArray[section][row].bathroomNumber
                }
            }
            break
        default:
            print("default segue prepare in bathroom table")
        }
    }
}

