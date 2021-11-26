//
//  DemoTableViewCell.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/23/20.
//

import UIKit

class DemoTableViewCell: UITableViewCell {
    
    @IBOutlet var bathroomName: UILabel!
    @IBOutlet var bathroomNumber: UILabel!
    @IBOutlet var ratingsCount: UILabel!
    @IBOutlet var avgRating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
