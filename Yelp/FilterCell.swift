//
//  FilterCell.swift
//  Yelp
//
//  Created by Dat Nguyen on 22/11/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        wrapView.layer.borderWidth=1
        wrapView.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }

}
