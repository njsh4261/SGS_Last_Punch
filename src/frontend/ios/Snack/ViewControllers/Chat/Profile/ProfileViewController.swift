//
//  ProfileViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/30.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD
import MessageUI

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileViewModel()
    private var userInfo: WorkspaceMemberCellModel?

    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var viewHeader: UIView!
    @IBOutlet private var ivUser: UIImageView!
    @IBOutlet private var lblInitials: UILabel!
    @IBOutlet private var lblName: UILabel!
    @IBOutlet private var lblDetails: UILabel!

    @IBOutlet private var ivHeaderMessage: UIImageView!
    @IBOutlet private var ivHeaderMobile: UIImageView!
    @IBOutlet private var ivHeaderVideo: UIImageView!
    @IBOutlet private var ivHeaderMail: UIImageView!
    @IBOutlet private var btnHeaderMessage: UIButton!
    @IBOutlet private var btnHeaderMobile: UIButton!
    @IBOutlet private var btnHeaderVideo: UIButton!
    @IBOutlet private var btnHeaderMail: UIButton!

    @IBOutlet private var cellStatus: UITableViewCell!
    @IBOutlet private var cellDescription: UITableViewCell!
    @IBOutlet private var cellCountry: UITableViewCell!
    @IBOutlet private var cellPhone: UITableViewCell!
    @IBOutlet private var cellMedia: UITableViewCell!
    @IBOutlet private var cellBlock: UITableViewCell!

    private var isChatEnabled = false
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, userInfo: WorkspaceMemberCellModel, isChat: Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.userInfo = userInfo
        self.isChatEnabled = isChat
    }
    
    override func viewDidLoad() {
        loadUser()
        bind(with: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(with viewModel: ProfileViewModel) {
        // MARK: Bind input
        btnHeaderMessage.rx.tap
            .bind(to: viewModel.input.btnMessageTapped)
            .disposed(by: disposeBag)
        
        btnHeaderMobile.rx.tap
            .subscribe(onNext: actionMobile)
            .disposed(by: disposeBag)
        
        btnHeaderMail.rx.tap
            .subscribe(onNext: actionMail)
            .disposed(by: disposeBag)
        

        // MARK: Bind output
        viewModel.push
            .drive(onNext: { (viewModel) in
                let viewController = ChatPrivateView("55", self.userInfo!.id.description, self.userInfo!)
                viewController.hidesBottomBarWhenPushed = true
                viewController.bind(viewModel)
                self.show(viewController, sender: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func actionMobile() {
        let number = "tel://\(userInfo?.phone ?? "010-1234-1234")"

        if let url = URL(string: number) {
            if (UIApplication.shared.canOpenURL(url)) {
                UIApplication.shared.open(url)
            } else {
                ProgressHUD.showFailed("전화를 할 수 없습니다")
            }
        }
    }
    
    func actionMail() {
        let subject = ""
        let message = ""

        if (MFMailComposeViewController.canSendMail()) {
            let mailCompose = MFMailComposeViewController()
            mailCompose.setToRecipients([userInfo?.email ?? "test@test.com"])
            mailCompose.setSubject(subject)
            mailCompose.setMessageBody(message, isHTML: false)
            mailCompose.mailComposeDelegate = self
            present(mailCompose, animated: true)
        } else {
            let link = "mailto:\(userInfo?.email ?? "test@test.com")?subject=\(subject)&body=\(message)"
            if let encoded = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: encoded) {
                    if (UIApplication.shared.canOpenURL(url)) {
                        UIApplication.shared.open(url)
                    } else {
                        ProgressHUD.showFailed("메일 전송 실패")
                    }
                }
            }
        }
    }

    // 모든 미디어 보기
    func actionMedia() {
        
    }
    
    func loadUser() {
        guard let userInfo = userInfo else { return }
        title = "프로필"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.tableHeaderView = viewHeader
        
        ivHeaderMessage.tintColor = isChatEnabled ? UIColor(named: "snackColor")! : .darkGray
        ivHeaderMobile.tintColor = UIColor(named: "snackColor")!
        ivHeaderMail.tintColor = UIColor(named: "snackColor")!
        btnHeaderMessage.isEnabled = isChatEnabled ? true : false
        btnHeaderMobile.isEnabled = true
        btnHeaderMail.isEnabled = true
        
        lblInitials.text = userInfo.name?.first?.description
        
        lblName.text = "\(userInfo.name ?? "")/\(userInfo.displayname ?? "닉네임 없음")"
        lblDetails.text = "마지막 수정일 : \(userInfo.modifydt.toDate()?.toString2() ?? "yy.MM.dd hh:mm")"
        
        cellStatus.detailTextLabel?.text = userInfo.status
        cellDescription.detailTextLabel?.text = userInfo.description ?? "설명 없음"
        cellCountry.detailTextLabel?.text = userInfo.country == "kor" ? "대한민국" : "해외"
        cellPhone.detailTextLabel?.text = userInfo.phone ?? "010-1234-1234"
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ProfileViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        if (result == MFMailComposeResult.sent) {
            ProgressHUD.showSucceed("메일 전송 성공")
        }
        controller.dismiss(animated: true)
    }
}

// MARK: - UITableView Data Source
extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) { return 4 }
        if (section == 1) { return 1 }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellStatus         }
        if (indexPath.section == 0) && (indexPath.row == 1) { return cellDescription    }
        if (indexPath.section == 0) && (indexPath.row == 2) { return cellCountry        }
        if (indexPath.section == 0) && (indexPath.row == 3) { return cellPhone          }
        if (indexPath.section == 1) && (indexPath.row == 0) { return cellMedia          }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.section == 1) && (indexPath.row == 0) { actionMedia()             }
    }
}
