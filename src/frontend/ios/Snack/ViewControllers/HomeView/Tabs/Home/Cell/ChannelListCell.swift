//
//  ChannelListCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class ChannelListCell: UITableViewCell {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    static let identifier = "ChannelListCell"
    var chatId: String = "0"

    // MARK: - UI
    private var lblName = UILabel()
    private var btnUnread = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    func setChennel(_ chennel: Channel) {
        chatId = chennel.chatId
        lblName.text = "#     \(chennel.name)"
    }
    
    // 읽지 않음
    func setUnread(_ isUnread: Bool) {
        if isUnread {
            lblName.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            btnUnread.backgroundColor = UIColor(named: "snackColor")
        } else {
            lblName.font = UIFont(name: "NotoSansKR-Regular", size: 16)
            btnUnread.backgroundColor = .clear
        }
    }
    
    private func attribute() {
        backgroundColor = UIColor(named: "snackButtonColor")

        lblName = lblName.then {
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        }
        
        btnUnread = btnUnread.then {
            $0.layer.cornerRadius = 10
        }
    }
    
    private func layout() {
        [lblName, btnUnread].forEach {
            contentView.addSubview($0)
        }
        
        lblName.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalTo(btnUnread.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        btnUnread.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
}
