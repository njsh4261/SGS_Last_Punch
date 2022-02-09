//
//  NewWorkspaceFirstViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class NewWorkspaceFirstViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = NewWorkspaceViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    private var btnNext = UIBarButtonItem()
    private var lblDescription = UILabel()
    private var newWorkspaceNameField = UITextField()
    private var lblWarning = UILabel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
                
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: NewWorkspaceViewModel) {
        // MARK: Bind input
        btnNext.rx.tap
            .bind(onNext: goToNewWorkspaceChennel)
            .disposed(by: disposeBag)
        
        // enter를 누를때
        newWorkspaceNameField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind(onNext: goToNewWorkspaceChennel)
            .disposed(by: disposeBag)
        
        newWorkspaceNameField.rx.text.orEmpty
            .bind(to: viewModel.input.newWorkspaceName)
            .disposed(by: disposeBag)
        
        // MARK: Bind output
        viewModel.output.isNameEnabled
            .observe(on: MainScheduler.instance)
            .bind(to: btnNext.rx.isEnabled, newWorkspaceNameField.rx.deleteWorkspaceNameBackward)
            .disposed(by: disposeBag)
        
        viewModel.output.isHidden
            .observe(on: MainScheduler.instance)
            .bind(to: lblWarning.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func goToNewWorkspaceChennel() {
        let navController = NewWorkspaceSecondViewController()
        navController.bind(with: viewModel)
        if newWorkspaceNameField.text == "새 워크스페이스" {
            newWorkspaceNameField.text = "새 워크스페이스"
        }
        navigationController?.pushViewController(navController, animated: true)
    }
        
    private func attribute() {
        view.backgroundColor = UIColor (named: "snackBackGroundColor")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "이름", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = btnNext
        
        btnNext = btnNext.then {
            $0.title = "다음"
            $0.style = .plain
        }
        
        lblDescription = lblDescription.then {
            $0.text = "워크스페이스 이름이 어떻게 됩니까?"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.textAlignment = .left
        }
        
        newWorkspaceNameField = newWorkspaceNameField.then {
            $0.text = "새 워크스페이스"
            $0.placeholder = "예: Last Punch Project"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 25)
            $0.textAlignment = .left
            $0.returnKeyType = .go
            $0.autocorrectionType = .no
        }
        
        lblWarning = lblWarning.then {
            $0.text = "최대 15자를 입력해주세요"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 14)
            $0.textColor = .lightGray
            $0.textAlignment = .left
            $0.isHidden = true
        }
    }
    
    private func layout() {
        [lblDescription, newWorkspaceNameField, lblWarning].forEach { view.addSubview($0) }
        
        [lblDescription, newWorkspaceNameField, lblWarning].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            }
        }
        
        lblDescription.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(175)
        }
        
        newWorkspaceNameField.snp.makeConstraints {
            $0.top.equalTo(lblDescription.snp.bottom)
            $0.height.equalTo(50)
        }
        
        lblWarning.snp.makeConstraints {
            $0.top.equalTo(newWorkspaceNameField.snp.bottom)
        }
    }
}
