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

class MemberListCell: UITableViewCell {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    static let identifier = "MemberListCell"
    var chatId: String = "0"

    // MARK: - UI
    private var ivThumbnail = UIImageView()
    private var lblName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMember(_ member: Member) {
        chatId = member.id
        ivThumbnail.image = UIImage(named: "snack")
        lblName.text = "\(member.name)"
    }

    private func attribute() {        
        ivThumbnail.contentMode = .scaleAspectFit

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
