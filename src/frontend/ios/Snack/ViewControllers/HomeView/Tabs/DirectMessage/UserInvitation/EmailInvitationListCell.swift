//
//  EmailInvitationListCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class EmailInvitationListCell: UITableViewCell {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    static let identifier = "EmailInvitationListCell"

    // MARK: - UI
    private var emailField = UITextField()

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

    private func attribute() {
        backgroundColor = UIColor(named: "snackButtonColor")

        emailField = emailField.then {
            $0.placeholder = "초대할 이메일 주소 입력"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let image = UIImage(named: "mail")
            imageView.image = image
            $0.leftView = imageView
            $0.clearButtonMode = .whileEditing
        }
    }
    
    private func layout() {
        contentView.addSubview(emailField)
        
        emailField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
