//
//  RestaurantCell.swift
//  Yelp
//
//  Created by Dat Nguyen on 21/11/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business: Business! {
        didSet{
            nameLabel.text = business.name!
            distanceLabel.text = business.distance!
            reviewLabel.text = String(business.reviewCount!) + " reviews"
            addressLabel.text = business.address!
            categoryLabel.text = business.categories!
            restaurantImageView.setImageWithURL(business.imageURL!)
            restaurantImageView.layer.cornerRadius = 8.0
            ratingImageView.setImageWithURL(business.ratingImageURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        //addressLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        //categoryLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
