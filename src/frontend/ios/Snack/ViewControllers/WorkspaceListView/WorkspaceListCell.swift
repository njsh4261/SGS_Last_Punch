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
    private var viewModel = WorkspaceListCellViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - UI
    var ivThumbnail = UIImageView()
    var lblName = UILabel()
    var lblAddress = UILabel()
    var btnCheckBox = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    private func bind(with viewModel: WorkspaceListCellViewModel) {
        //MARK: Bind input
        // Toggle
        btnCheckBox.rx.tap
            .asDriver()
            .drive(btnCheckBox.rx.setCheckImage)
            .disposed(by: disposeBag)
        
        //MARK: Bind output
    }
    
    private func attribute() {
        backgroundColor = UIColor(named: "snackBackGroundColor")
        ivThumbnail.contentMode = .scaleAspectFit
        
        lblName = lblName.then {
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        }
        
        lblAddress = lblAddress.then {
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 10)
            $0.textColor = .lightGray
            $0.numberOfLines = 1
        }
        
        btnCheckBox = btnCheckBox.then {
            $0.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 5
//            $0.tintColor = UIColor(named: "snackBackGroundColor")
        }
    }
    
    private func layout() {
        [ivThumbnail, lblName, lblAddress, btnCheckBox].forEach {
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
            $0.trailing.lessThanOrEqualTo(btnCheckBox.snp.leading).offset(-8)
        }

        lblAddress.snp.makeConstraints {
            $0.top.equalTo(lblName.snp.bottom)
            $0.leading.equalTo(lblName)
            $0.trailing.equalTo(btnCheckBox.snp.leading).offset(-8)
        }
        
        btnCheckBox.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
    
    func setData(_ data: WorkspaceListCellModel) {
        ivThumbnail.image = UIImage(named: "snack")
        lblName.text = data.name
        lblAddress.text = data.createdt
    }
}

extension Reactive where Base: UIButton {
    
    var setCheckImage: Binder<()> {
        return Binder(base, binding: { (button, _) in
            if button.image(for: .normal) == UIImage(systemName: "eye.slash.fill") {
                button.setImage(UIImage(named: "checkmark"), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
                button.backgroundColor = UIColor(named: "snackColor")
            }
        })
    }
}
