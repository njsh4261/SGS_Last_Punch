//
//  NoteListReusableView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class NoteListReusableView: UICollectionReusableView {
    // MARK: - UI
    private var lblTitle = UILabel()
    private var lblDescription = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
        attribute()
    }
    
    private func attribute() {
        [lblTitle, lblDescription].forEach {
            $0.textColor = UIColor(named: "snackTextColor")
        }
        
        lblTitle = lblTitle.then {
            $0.text = "안녕하세요!"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 30)
        }
        
        lblDescription = lblDescription.then {
            $0.text = "Slack에서는 공동편집을 할 수 있는 \n노트 기능을 제공하고 있습니다.\n노트를 생성하여 멤버들과 작업해보세요."
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 16)
            $0.textAlignment = .center
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
        }
    }
    
    private func layout() {
        [lblTitle, lblDescription].forEach {
            self.addSubview($0)
        }
        
        [lblTitle, lblDescription].forEach {
            $0.snp.makeConstraints {
                $0.centerX.equalTo(self.safeAreaLayoutGuide)
            }
        }
        
        lblTitle.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
        
        lblDescription.snp.makeConstraints {
            $0.left.right.equalTo(self.safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(85)
        }
    }
}
