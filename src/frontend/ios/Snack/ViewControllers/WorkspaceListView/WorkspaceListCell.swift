//
//  WorksapceListCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/20.
//

import UIKit
import SnapKit
import Then

class WorkspaceListCell: UITableViewCell {
    var ivThumbnail = UIImageView()
    var lblName = UILabel()
    var lblAddress = UILabel()
    var btnCheckbox = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    private func attribute() {
        ivThumbnail.contentMode = .scaleAspectFit
        
        lblName = lblName.then {
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        }
        
        lblAddress = lblAddress.then {
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 10)
            $0.textColor = .lightGray
            $0.numberOfLines = 1
        }
        
        btnCheckbox = btnCheckbox.then {
            $0.setTitle("클릭", for: .normal)
//            $0.layer.cornerRadius = 5
        }
    }
    
    private func layout() {
        [ivThumbnail, lblName, lblAddress, btnCheckbox].forEach {
            contentView.addSubview($0)
        }
        
        ivThumbnail.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.left.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(30)
        }

        lblName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalTo(ivThumbnail.snp.right).offset(10)
            $0.trailing.lessThanOrEqualTo(btnCheckbox.snp.leading).offset(-8)
        }

        lblAddress.snp.makeConstraints {
            $0.top.equalTo(lblName.snp.bottom)
            $0.leading.equalTo(lblName)
            $0.trailing.equalTo(btnCheckbox.snp.leading).offset(-8)
        }
        
        btnCheckbox.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.right.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(50)
        }
    }
    
    func setData(_ data: WorkspaceListCellModel) {
        ivThumbnail.image = UIImage(named: "snack")
        lblName.text = data.name
        lblAddress.text = data.createdt
    }
}
