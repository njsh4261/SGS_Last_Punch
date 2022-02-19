//
//  MemberListCell.swift
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

class MemberListCell: UITableViewCell {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    static let identifier = "MemberListCell"
    var chatId: String = ""
    var userId: String = ""

    // MARK: - UI
    private var ivThumbnail = UIImageView()
    private var lblName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        guard let userId: String = KeychainWrapper.standard[.id] else { return }
        self.userId = userId
        attribute()
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMember(_ member: Member, _ index: Int) {
        chatId = member.id > userId ? "\(member.id)-\(userId)" : "\(userId)-\(member.id)"
        ivThumbnail.image = index%2 == 0 ? UIImage(named: "10")?.square(to: 70) : UIImage(named: "13")?.square(to: 70)
        lblName.text = member.id == userId ? "\(member.name) (나)" : "\(member.name)"
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
    }
    
    private func layout() {
        [ivThumbnail, lblName].forEach {
            contentView.addSubview($0)
        }
        
        ivThumbnail.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.width.height.equalTo(25)
        }

        lblName.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(ivThumbnail.snp.right).offset(10)
        }
    }
}
