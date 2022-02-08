//
//  NoteListCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class NoteListCell: UICollectionViewCell {
    
    // MARK: - Properties
    var data: NoteListCellModel?
    
    // MARK: - UI
    var id: String?
    var lblName = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15

        attribute()
        layout()
    }
    
    func setData(_ data: NoteListCellModel, _ row: Int) {
        self.data = data
        self.id = data.id
        self.lblName.text = data.title + row.description
    }
    
    private func attribute() {
        backgroundColor = UIColor(named: "snackButtonColor")
        
        lblName = lblName.then {
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.numberOfLines = 3
        }
    }
    
    private func layout() {
        contentView.addSubview(lblName)
        
        lblName.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(safeAreaLayoutGuide).offset(10)
            $0.trailing.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-10)
        }
    }
}
