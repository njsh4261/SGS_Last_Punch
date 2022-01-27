//
//  MessageView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/27.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import ProgressHUD
import SwiftKeychainWrapper
import InputBarAccessoryView

class MessageView: UIViewController {
    // MARK: - Properties
    private let viewModel = WorkspaceListViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        guard let token: String = KeychainWrapper.standard[.refreshToken] else { return }
        NSLog("accessToken: " + token)
        
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: WorkspaceListViewModel) {
        // MARK: Bind input
        
        // MARK: Bind output

    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        
    }
}
