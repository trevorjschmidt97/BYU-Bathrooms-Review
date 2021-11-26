//
//  UserReviewCell.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 1/3/21.
//

import UIKit
import Cosmos

class UserReviewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ratingCosmosView: CosmosView!
    @IBOutlet weak var bathroomLable: UILabel!
    
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
}
