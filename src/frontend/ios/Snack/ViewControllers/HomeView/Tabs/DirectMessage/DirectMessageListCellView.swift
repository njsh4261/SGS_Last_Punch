//
//  DirectMessageListCellView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class DirectMessageListCellView: UITableViewCell {
    
    // MARK: - UI
    var index: Int = 0
    var ivThumbnail = UIImageView()
    var lblName = UILabel()
    var lblLastMessage = UILabel()
    var lblDate = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15
        
        attribute()
        layout()
    }
    
    func setData(_ data: User, _ index: Int) {
        ivThumbnail.image = (index/2) == 0 ? UIImage(named: "snack") : UIImage(named: "snack_solid")
        lblName.text = data.name
        lblLastMessage.text = data.description ?? "\(data.name!)님이 Snack의 멤버로 참가하였습니다.\n'안녕하세요'로 대화를 시작해보세요."
        lblDate.text = data.modifyDt.toDate()?.toString()
    }
    
    private func attribute() {
        backgroundColor = UIColor(named: "snackButtonColor")
        
        ivThumbnail.contentMode = .scaleAspectFit
        
        lblName = lblName.then {
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        }
        
        lblLastMessage = lblLastMessage.then {
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 13)
            $0.textColor = .lightGray
            $0.lineBreakMode = .byCharWrapping
            $0.numberOfLines = 2
        }
        
        lblDate = lblDate.then {
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 10)
            $0.textColor = .lightGray
            $0.numberOfLines = 1
        }
    }
    
    private func layout() {
        [ivThumbnail, lblName, lblLastMessage, lblDate].forEach {
            contentView.addSubview($0)
        }
        
        ivThumbnail.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.width.height.equalTo(30)
        }
        
        lblName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalTo(ivThumbnail.snp.right).offset(10)
        }
        
        lblLastMessage.snp.makeConstraints {
            $0.top.equalTo(lblName.snp.bottom)
            $0.leading.equalTo(lblName)
            $0.trailing.equalToSuperview().offset(-10)
        }

        lblDate.snp.makeConstraints {
            $0.bottom.equalTo(lblLastMessage.snp.top)
            $0.right.equalToSuperview().inset(15)
        }
    }
}
