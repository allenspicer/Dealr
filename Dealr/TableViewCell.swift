//
//  TableViewCell.swift
//  Dealr
//
//  Created by Allen Spicer on 11/1/17.
//  Copyright © 2017 Allen Spicer. All rights reserved.
//

import UIKit

class DealershipTableViewCell: UITableViewCell {

    @IBOutlet weak var dealershipListTitleLabel: UILabel!
    @IBOutlet weak var dealershipCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
