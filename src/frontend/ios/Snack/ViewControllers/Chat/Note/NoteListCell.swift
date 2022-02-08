//
//  NoteListCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
//

import UIKit
import SnapKit
import Then

class NoteListCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var note: Note?
    
    // MARK: - UI
    private var id: String?
    private var lblName = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15

        attribute()
        layout()
    }
    
    func setData(_ note: Note, _ row: Int) {
        self.note = note
        self.id = note.id
        self.lblName.text = note.title == "Untitled" ? note.title + row.description : note.title
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
