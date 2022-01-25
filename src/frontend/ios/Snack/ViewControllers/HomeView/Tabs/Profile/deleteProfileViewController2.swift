////
////  ProfileViewController2.swift
////  Snack
////
////  Created by ghyeongkim-MN on 2022/01/17.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import SnapKit
//import RxDataSources
//import Then
//
//class ProfileViewController2: UITableViewController {
//
//    // MARK: - Properties
//    private var viewModel = ProfileViewModel()
//    private let disposeBag = DisposeBag()
//    private var dataSource: RxTableViewSectionedReloadDataSource<ProfileSection>!
//    private var todoSections: BehaviorRelay<[ProfileSection]> = BehaviorRelay(value: [])
//
//    // MARK: - UI
//    // Section 1
//    private var tableView = UITableView()
//    private var viewHeader = UIView()
//    private var ivUser = UIImageView()
//    private var labelName = UILabel()
////    private var cellProfile = UITableViewCell()
////    private var cellPassword = UITableViewCell()
////    // Section 2
////    private var cellStatus = UITableViewCell()
////    // Section 3
////    private var cellCache = UITableViewCell()
////    private var cellMedia = UITableViewCell()
////    // Section 4
////    private var cellLogout = UITableViewCell()
////    private var deleteEmail = UITableViewCell()
//
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//
//        bind(with: viewModel)
//        attribute()
//        layout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func bind(with viewModel: ProfileViewModel) {
//        dataSource = RxTableViewSectionedReloadDataSource<ProfileSection> { dataSource, tableView, indexPath, item in
//            switch dataSource[indexPath] {
//            case let .empty
//            }
//            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
//
//            // cell 설정
//            cell.bind(task: item)
//
//            return cell
//        }
//
//        // 섹션 문자
//        dataSource.titleForHeaderInSection = { ds, index in
//            return ProfileSectionType.
//        }
//
//
//
//        // 기본적인 cell 분배
//        viewModel.cellData
//            .drive(tableView.rx.items) { tv, row, data in
//                switch row {
//                case 0...6:
//                    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: ProfileCell.self), for: IndexPath(row: row, section: 0)) as! ProfileCell
//                    cell.selectionStyle = .none
//                    cell.textLabel?.text = data
//                    cell.accessoryType = .disclosureIndicator
//                    return cell
//                case 7:
//                    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: ProfileCell.self), for: IndexPath(row: row, section: 1)) as! ProfileCell
//                    cell.selectionStyle = .none
//                    cell.textLabel?.text = data
//                    cell.accessoryType = .disclosureIndicator
//                    return cell
//                default:
//                    fatalError()
//                }
//            }
//            .disposed(by: disposeBag)
//
//    }
//
//    private func attribute() {
//        title = "나"
//        tabBarItem.image = UIImage(systemName: "person.crop.circle")
//        tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
//        view.backgroundColor = UIColor(named: "snackBackGroundColor")
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
//
//        tableView = tableView.then {
//            $0.backgroundColor = UIColor(named: "profileBackGroundColor")
//            $0.separatorStyle = .singleLine
//            $0.bouncesZoom = false
//            $0.rowHeight = UITableView.automaticDimension
//            $0.alwaysBounceVertical = false
//            $0.isOpaque = false
//            $0.clipsToBounds = false
//
//            tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
//        }
//
//        viewHeader = viewHeader.then {
//            $0.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 120))
//            tableView.tableHeaderView = $0
//        }
//
//        ivUser = ivUser.then {
//            $0.image = UIImage(named: "snack")
//            $0.contentMode = .scaleToFill
//            $0.clipsToBounds = false
//        }
//
//        labelName = labelName.then {
//            $0.text = "Name"
//            $0.font = UIFont(name: "NotoSansKR-Bold", size: 17)
//            $0.textColor = UIColor(named: "snackTextColor")
//            $0.textAlignment = .center
//        }
//    }
//
//    private func layout() {
//        view.addSubview(tableView)
//
//        [ivUser, labelName].forEach {
//            viewHeader.addSubview($0)
//        }
//
//        tableView.snp.makeConstraints {
//            $0.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
//
//        ivUser.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().offset(15)
//            $0.width.height.equalTo(70)
//        }
//
//        labelName.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.top.equalToSuperview().offset(95)
//            $0.height.equalTo(30)
//        }
//    }
//}
//
