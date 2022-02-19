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
import SwiftKeychainWrapper

class EditWorkspaceView: UIViewController {
    // MARK: - Properties
    private var worspaceInfo: WorkspaceListCellModel?
    private var selectImage: Int?

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
        fieldDescription.text = worspaceInfo.description ?? "설명이 없습니다"
        tableView.reloadData()
    }

    @objc func actionDismiss() {
        dismiss(animated: true)
    }
    
    @objc func actionSave() {

        let name = fieldName.text ?? ""

        if (name.isEmpty)           { ProgressHUD.showFailed("이름은 반드시 작성해야합니다");        return  }

        ProgressHUD.showSucceed("변경되었습니다")
        dismiss(animated: true)
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

