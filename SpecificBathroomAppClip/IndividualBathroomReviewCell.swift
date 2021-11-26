//
//  BathroomCell.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/23/20.
//

import UIKit
import Cosmos
import StoreKit

class IndividualBathroomReviewCell: UITableViewCell {
    
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
//    var ratingID: Int!
//    var buildingID: String!
//    var bathroomNumber: String!
//    var username: String!
//    var userID: String!
    
    // Click Like
    @IBAction func clickLike(_ sender: Any) {
        guard let scene = parentViewController?.view.window?.windowScene else { return }

        let config = SKOverlay.AppClipConfiguration(position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.present(in: scene)

    }
    
    @IBAction func clickDislike(_ sender: Any) {
        guard let scene = parentViewController?.view.window?.windowScene else { return }

        let config = SKOverlay.AppClipConfiguration(position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.present(in: scene)
    }
}



extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
}
