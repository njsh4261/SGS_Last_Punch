//
//  ChannelCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class ChannelCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: ChannelCellViewModel) {

    }

    private func attribute() {

    }
    
    private func layout() {

    }
}
