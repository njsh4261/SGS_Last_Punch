//
//  UserSearchTableViewCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/14.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivThunbnail: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
