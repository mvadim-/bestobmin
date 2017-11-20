//
//  CurrencyTableViewCell.swift
//  BestObmin
//
//  Created by Vadym on 11/20/17.
//  Copyright © 2017 Vadym Maslov. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var sell: UILabel!
    @IBOutlet weak var buy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
