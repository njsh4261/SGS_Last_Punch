//
//  EditProfileViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/18.
//

import UIKit
import ProgressHUD
import RxSwift
import RxCocoa
import Alamofire
import SwiftKeychainWrapper

class EditProfileView: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var userInfo: UserModel?
    private var selectImage: Int?
    private var accessToken: String?

    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var viewHeader: UIView!
    @IBOutlet private var ivUser: UIImageView!
    @IBOutlet private var lblInitials: UILabel!
    @IBOutlet private var cellName: UITableViewCell!
    @IBOutlet private var cellDescription: UITableViewCell!
    @IBOutlet private var cellCountry: UITableViewCell!
    @IBOutlet private var cellPhone: UITableViewCell!
    @IBOutlet private var fieldName: UITextField!
    @IBOutlet private var lblPlaceholder: UILabel!
    @IBOutlet private var lblCountry: UILabel!
    @IBOutlet private var fieldDescription: UITextField!
    @IBOutlet private var fieldPhone: UITextField!
    
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.accessToken = KeychainWrapper.standard[.accessToken]!
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "프로필 편집"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(actionDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(actionSave))

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false

        tableView.tableHeaderView = viewHeader
        loadUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dismissKeyboard()
    }
    
    // MARK: - Keyboard methods
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Load User
    func loadUser() {
        if let data = KeychainWrapper.standard.data(forKey: "userInfo") {
            let userInfo = try? PropertyListDecoder().decode(UserModel.self, from: data)
            self.userInfo = userInfo
        }
        
        guard let userInfo = userInfo else {
            return
        }

        if userInfo.imageNum != nil {
            self.ivUser.image = UIImage(named: "\(userInfo.imageNum!)")?.square(to: 70)
            self.ivUser.backgroundColor = UIColor(named: "snackButtonColor")
            self.lblInitials.backgroundColor = .clear
            self.lblInitials.text = nil
        } else {
            lblInitials.text = userInfo.name.first?.description
            self.lblInitials.backgroundColor = .lightGray
            self.ivUser.backgroundColor = .clear
            self.ivUser.image = nil
        }
        
        fieldName.text = userInfo.name
        fieldDescription.text = userInfo.description
        lblCountry.text = userInfo.country == "kor" ? "대한민국" : "해외"
        fieldPhone.text = userInfo.phone

        lblPlaceholder.isHidden = (lblCountry.text != "")
        
        tableView.reloadData()
    }

    @objc func actionDismiss() {
        dismiss(animated: true)
    }
    
    @objc func actionSave() {
        
        let name = fieldName.text ?? ""
        let description = fieldDescription.text ?? ""
        let phone = fieldPhone.text ?? ""
        let select = selectImage ?? 0

        if (name.isEmpty)           { ProgressHUD.showFailed("이름은 반드시 작성해야합니다");        return  }

        let body = select == 0 ? ["name": name, "description": description, "phone": phone] : ["name": name, "description": description, "phone": phone, "imageNum": select]
        editAccount(body: body)
    }
    
    func editAccount(body: Parameters) {
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            AccountService.shared.editAcctount(method: .put, accessToken: self.accessToken!, userId: (userInfo?.id.description)!, body: body)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success:
                            ProgressHUD.showSucceed("변경되었습니다")
                            setAccount(body: body)
                            self.actionDismiss()
                        case .fail(let decodedData):
                            ProgressHUD.showFailed(decodedData.err?.desc)
                        default:
                            ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                        }
                    default:
                        ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                    }
                }.disposed(by: self.disposeBag)
        }
    }
    
    func setAccount(body: Parameters) {
        var userInfo = userInfo
        
        userInfo?.name = body["name"] as! String
        userInfo?.description = body["description"] as? String
        userInfo?.phone = body["phone"] as? String
        userInfo?.imageNum = selectImage
        
        KeychainWrapper.standard.set(try! PropertyListEncoder().encode(userInfo), forKey: "userInfo")
    }
    
    @IBAction func actionPhoto(_ sender: Any) {
        let viewController = SelectImageView()
        let navController = NavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        
        viewController.completionHandler = { index, image in
            self.ivUser.image = image.square(to: 70)
            self.ivUser.backgroundColor = UIColor(named: "snackButtonColor")
            self.lblInitials.backgroundColor = .clear
            self.lblInitials.text = nil
            self.selectImage = index
            
            return (index, image)
        }
        self.show(navController, sender: nil)
    }
}
// MARK: - UITableView DataSource
extension EditProfileView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (section == 0) { return 3 }
        if (section == 1) { return 1 }

        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) { return "정보" }
        if (section == 1) { return "전화번호" }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellName           }
        if (indexPath.section == 0) && (indexPath.row == 1) { return cellDescription    }
        if (indexPath.section == 0) && (indexPath.row == 2) { return cellCountry        }
        if (indexPath.section == 1) && (indexPath.row == 0) { return cellPhone          }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension EditProfileView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 0) && (indexPath.row == 2) {
            
        }
    }
}

// MARK: - UITextField Delegate
extension EditProfileView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if (textField == fieldName)         { fieldName.becomeFirstResponder()          }
        if (textField == fieldDescription)  { fieldPhone.becomeFirstResponder()         }
        if (textField == fieldPhone)        { actionSave()                              }

        return true
    }
}

