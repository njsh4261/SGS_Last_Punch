//
//  ChatsViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import Then

class ChatsViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = ChatsViewModel(RegisterService())
    private let disposeBag = DisposeBag()
    private var chatObjects: [ChatObject] = []
    private var observerId: String?
    
    // MARK: - UI
    private var searchBar: UISearchBar!
    private var tableView: UITableView!

    var fieldPassword = UITextField()
    var emailBorder = UIView()
    var passwordBorder = UIView()
    var btnSignIn = UIButton()
    var lblWarning = UILabel()
    var btnSignUp = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: ChatsViewModel) {
        
        
    }
    
    private func attribute() {
        title = "Workspace명"
        tabBarItem.image = UIImage(systemName: "house")
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        tabBarItem.title = "홈"
        
        view.backgroundColor = UIColor(named: "snackBackgroundColor")
        
    }
    
    private func layout() {
       
    }
}
