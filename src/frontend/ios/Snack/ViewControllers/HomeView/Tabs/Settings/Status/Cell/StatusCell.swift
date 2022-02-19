//
//  StatusCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/19.
//

import UIKit

class StatusCell: UITableViewCell {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    //    @IBOutlet weak var lblStatus: UILabel!
//    @IBOutlet weak var btnStatus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnStatus.layer.cornerRadius = btnStatus.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
