//
//  UserListCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class UserListCell: UITableViewCell {
    let disposeBag = DisposeBag()
    static let identifier = "UserListCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: UserListCellViewModel) {

    }

    private func attribute() {
        backgroundColor = .blue
    }
    
    private func layout() {

    }
}
