//
//  SelectImageCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/19.
//

import UIKit

class SelectImageCell: UICollectionViewCell {

    @IBOutlet private var imageItem: UIImageView!

    func bindData(_ image: UIImage) {

        imageItem.image = image
    }
}
