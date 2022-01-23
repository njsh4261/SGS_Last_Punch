//
//  WorksapceListCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/20.
//

import UIKit
import SnapKit
import Then

class WorksapceListCell: UITableViewCell {
    var ivThumbnail = UIImageView()
    var lblName = UILabel()
    var lblAddress = UILabel()
    var btnCheckbox = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .red
        attribute()
        layout()
    }
    
    private func attribute() {
        ivThumbnail.contentMode = .scaleAspectFit
        
        lblName.font = .systemFont(ofSize: 18, weight: .bold)
        
        lblAddress = lblAddress.then {
            $0.font = .systemFont(ofSize: 14)
            $0.numberOfLines = 1
        }
        
        btnCheckbox = btnCheckbox.then {
            $0.layer.cornerRadius = 5
        }
    }
    
    private func layout() {
        [ivThumbnail, lblName, lblAddress, btnCheckbox].forEach {
            contentView.addSubview($0)
        }
        
        ivThumbnail.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.left.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(30)
        }
        
        lblName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalTo(ivThumbnail.snp.right).offset(10)
            $0.trailing.lessThanOrEqualTo(btnCheckbox.snp.leading).offset(-8)

        }
        
        lblAddress.snp.makeConstraints {
            $0.top.equalTo(lblName.snp.bottom).offset(8)
            $0.leading.equalTo(lblName)
            $0.trailing.lessThanOrEqualTo(btnCheckbox.snp.leading).offset(-8)

        }
        
        btnCheckbox.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.trailing.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(5)
        }
    }
    
    func setData(_ data: WorkspaceListCellData) {
        ivThumbnail.image = UIImage(named: "snack")
        lblName.text = data.name
        lblAddress.text = data.title
    }
}
