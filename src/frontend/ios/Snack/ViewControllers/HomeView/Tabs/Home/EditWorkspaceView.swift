//
//  EditWorkspaceView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/19.
//

import UIKit
import ProgressHUD
import RxSwift
import RxCocoa
import Alamofire
import SwiftKeychainWrapper

class EditWorkspaceView: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var worspaceInfo: WorkspaceListCellModel?
    private var selectImage: Int?
    private var workspaceId: String
    private var accessToken: String

    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var viewHeader: UIView!
    @IBOutlet private var ivWorkspace: UIImageView!
    @IBOutlet private var lblInitials: UILabel!
    @IBOutlet private var cellName: UITableViewCell!
    @IBOutlet private var fieldName: UITextField!
    @IBOutlet private var cellDescription: UITableViewCell!
    @IBOutlet private var fieldDescription: UITextField!

    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.workspaceId = KeychainWrapper.standard[.workspaceId]!
        self.accessToken = KeychainWrapper.standard[.accessToken]!

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "워크스페이스 편집"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(actionDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(actionSave))

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false

        tableView.tableHeaderView = viewHeader
        
        // 워크스페이 정보 Load
        loadWorkspace()
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

    // MARK: - Load Workspace
    func loadWorkspace() {
        if let data = KeychainWrapper.standard.data(forKey: "workspaceInfo") {
            let worspaceInfo = try? PropertyListDecoder().decode(WorkspaceListCellModel.self, from: data)
            self.worspaceInfo = worspaceInfo!
        }
        
        guard let worspaceInfo = worspaceInfo else {
            return
        }
        
        if worspaceInfo.imageNum != nil {
            self.ivWorkspace.image = UIImage(named: "\(worspaceInfo.imageNum!)")?.square(to: 70)
            self.ivWorkspace.backgroundColor = UIColor(named: "snackButtonColor")
            self.lblInitials.backgroundColor = .clear
            self.lblInitials.text = nil
        } else {
            lblInitials.text = worspaceInfo.name.first?.description
            self.lblInitials.backgroundColor = .lightGray
            self.ivWorkspace.backgroundColor = .clear
            self.ivWorkspace.image = nil
        }
        
        fieldName.text = worspaceInfo.name
        if worspaceInfo.description == nil || worspaceInfo.description == "" {
            fieldDescription.placeholder = "설명이 없습니다"
        }
        tableView.reloadData()
    }

    @objc func actionDismiss() {
        dismiss(animated: true)
    }
    
    @objc func actionSave() {

        let name = fieldName.text ?? ""
        let description = fieldDescription.text ?? ""
        let select = selectImage ?? 0

        if (name.isEmpty)           { ProgressHUD.showFailed("이름은 반드시 작성해야합니다");        return  }

        // 네트워크 로직
        let body = select == 0 ? ["name": name, "description": description] : ["name": name, "description": description, "imageNum": select]
        editWorkspace(body: body)
    }
    
    func editWorkspace(body: Parameters) {
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            WorkspaceService.shared.editWorkspace(method: .put, accessToken: self.accessToken, workspaceId: self.workspaceId, body: body)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success:
                            ProgressHUD.showSucceed("변경되었습니다")
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
    
    @IBAction func actionPhoto(_ sender: Any) {
        let viewController = SelectImageView()
        let navController = NavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen

        viewController.completionHandler = { index, image in
            self.ivWorkspace.image = image.square(to: 70)
            self.ivWorkspace.backgroundColor = UIColor(named: "snackButtonColor")
            self.lblInitials.backgroundColor = .clear
            self.lblInitials.text = nil
            self.selectImage = index
            
            return (index, image)
        }
        
        self.show(navController, sender: nil)
    }
}

// MARK: - UITableView DataSource
extension EditWorkspaceView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (section == 0) { return 1 }
        if (section == 1) { return 1 }

        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) { return "정보" }
        if (section == 1) { return "설명" }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellName           }
        if (indexPath.section == 1) && (indexPath.row == 0) { return cellDescription    }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension EditWorkspaceView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextField Delegate
extension EditWorkspaceView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if (textField == fieldName)         { fieldDescription.becomeFirstResponder()       }

        return true
    }
}

