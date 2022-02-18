//
//  DirectMessageListViewCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then
import SwiftKeychainWrapper

class DirectMessageListViewCell: UITableViewCell {
    // MARK: - Properties
    var index: Int = 0
    var chatId = ""
    var userId = ""

    // MARK: - UI
    var ivThumbnail = UIImageView()
    var lblName = UILabel()
    var lblLastMessage = UILabel()
    var lblDate = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        guard let userId: String = KeychainWrapper.standard[.id] else { return }
        self.userId = userId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15
        
        attribute()
        layout()
    }
    
    func setData(_ member: User, _ index: Int) {
        chatId = member.senderId > userId ? "\(member.senderId)-\(userId)" : "\(userId)-\(member.senderId)"
        ivThumbnail.image = index%2 == 0 ? UIImage(named: "10")?.square(to: 70) : UIImage(named: "13")?.square(to: 70)
        lblDate.text = Date().toString()

        if member.senderId == userId {
            lblName.text =  "\(member.displayName) (나)"
            lblLastMessage.text = "고객님만 사용하는 스페이스입니다. 메시지 초안을 작성하거나, 할 일 목록을 만들거나, 링크와 파일을 쉽게 보관해보세요. 또한 여기에서 혼잣말을 할 수도 있지만 혼자서 대화를 주고받으셔야 한다는 점에 유의하세요"
        } else {
            lblName.text = "\(member.displayName)"
            if member.content == "" {
                if member.authorId == userId {
                    lblLastMessage.text = "나 : \(member.content)"
                } else {
                    lblLastMessage.text = "\(member.displayName)님이 Snack의 멤버로 참가하였습니다.\n'안녕하세요'로 대화를 시작해보세요."
                }
            } else {
                lblLastMessage.text = member.content
            }
        }
    }
    
    // 읽지 않음
    func setUnread(_ isUnread: Bool) {
        if isUnread {
            lblLastMessage.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        } else {
            lblLastMessage.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        }
    }

    private func attribute() {
        backgroundColor = UIColor(named: "snackButtonColor")
        
        ivThumbnail = ivThumbnail.then {
            $0.contentMode = .scaleAspectFit
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.label.cgColor
            $0.layer.cornerRadius = 4
        }
        
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
