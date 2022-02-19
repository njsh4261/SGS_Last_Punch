//
//  WorksapceListCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/20.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class WorkspaceListCell: UITableViewCell {
    
    // MARK: - Properties
    var workspaceId: Int = -1
    
    // MARK: - UI
    var ivThumbnail = UIImageView()
    var lblInitials = UILabel()
    var lblName = UILabel()
    var lblAddress = UILabel()
    var btnCheckBox = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        attribute()
        layout()
    }
    
    func setData(_ data: WorkspaceListCellModel, _ index: Int) {
        workspaceId = data.id
        
        if data.imageNum != nil {
            ivThumbnail.image = UIImage(named: "\(data.imageNum!)")?.square(to: 70)
            ivThumbnail.backgroundColor = .white
            lblInitials.text = nil
            lblInitials.backgroundColor = .clear
        } else {
            lblInitials.text = data.name.first?.description
            lblInitials.backgroundColor = UIColor(named: "snackButtonColor")
            ivThumbnail.image = nil
            ivThumbnail.backgroundColor = .clear
        }
        
        lblName.text = data.name
        lblAddress.text = "고유주소 : \(data.id)"
        
        btnCheckBox.setImage(nil, for: .normal)
    }
    
    private func attribute() {
        backgroundColor = UIColor(named: "snackBackGroundColor")
        
        ivThumbnail = ivThumbnail.then {
            $0.contentMode = .scaleAspectFit
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.label.cgColor
            $0.layer.cornerRadius = 4
        }
        
        lblInitials = lblInitials.then {
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 20)
            $0.textColor = .label
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.label.cgColor
            $0.textAlignment = .center
        }
        
        lblName = lblName.then {
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        }
        
        lblAddress = lblAddress.then {
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 10)
            $0.textColor = .lightGray
            $0.numberOfLines = 1
        }
        
        btnCheckBox = btnCheckBox.then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 5
            $0.tintColor = UIColor(named: "snackColor")
        }
    }
    
    private func layout() {
        [ivThumbnail, lblInitials, lblName, lblAddress, btnCheckBox].forEach {
            contentView.addSubview($0)
        }
        
        [ivThumbnail, lblInitials].forEach {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().inset(10)
                $0.width.height.equalTo(30)
            }
        }

        lblName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalTo(ivThumbnail.snp.right).offset(10)
            $0.trailing.lessThanOrEqualTo(btnCheckBox.snp.leading).offset(-8)
        }

        lblAddress.snp.makeConstraints {
            $0.top.equalTo(lblName.snp.bottom)
            $0.leading.equalTo(lblName)
            $0.trailing.equalTo(btnCheckBox.snp.leading).offset(-8)
        }
        
        btnCheckBox.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
            $0.width.height.equalTo(20)
        }
    }
}
