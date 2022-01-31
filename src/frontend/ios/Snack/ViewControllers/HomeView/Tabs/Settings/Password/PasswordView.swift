//
//  PasswordView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/31.
//

import UIKit
import ProgressHUD

class PasswordView: UIViewController {
    // MARK: - Properties
//    private var userInfo: User?
    
    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var cellCurrentPassword: UITableViewCell!
    @IBOutlet private var cellNewPassword: UITableViewCell!
    @IBOutlet private var cellRetypePassword: UITableViewCell!
    
    @IBOutlet private var fieldCurrentPassword: UITextField!
    @IBOutlet private var fieldNewPassword: UITextField!
    @IBOutlet private var fieldRetypePassword: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()
        title = "비밀번호 변경"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(actionDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(actionSave))

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fieldCurrentPassword.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dismissKeyboard()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Network actions
    func checkPassword() {
        let _ = fieldCurrentPassword.text ?? ""

        ProgressHUD.show(nil, interaction: false)
        // 서버 저장 로직이 필요합니다.
        // 1. 자신의 비밀번호와 맞는지 확인
        // 2. 새로운 비밀번호를 저장
        let _ = fieldNewPassword.text ?? ""
        ProgressHUD.showSucceed("비밀번호가 변경되었습니다")
        dismiss(animated: true)
    }

    // MARK: - User actions
    @objc func actionDismiss() {
        dismiss(animated: true)
    }

    @objc func actionDone() {

        let password0 = fieldCurrentPassword.text ?? ""
        let password1 = fieldNewPassword.text ?? ""
        let password2 = fieldRetypePassword.text ?? ""

        if (password0.isEmpty)          { ProgressHUD.showFailed("현재 비밀번호를 입력해주세요");        return    }
        if (password1.isEmpty)          { ProgressHUD.showFailed("새로운 비밀번호를 입력해주세요");       return    }
        if (password1 != password2)     { ProgressHUD.showFailed("비밀번호가 일치하지 않습니다");        return    }

        checkPassword()
    }
}

// MARK: - UITableView DataSource
extension PasswordView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (section == 0) { return 1 }
        if (section == 1) { return 2 }

        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) { return "현재 비밀번호" }
        if (section == 1) { return "새 비밀번호" }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellCurrentPassword    }
        if (indexPath.section == 1) && (indexPath.row == 0) { return cellNewPassword        }
        if (indexPath.section == 1) && (indexPath.row == 1) { return cellRetypePassword     }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension PasswordView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextField Delegate
extension PasswordView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if (textField == fieldCurrentPassword)  { fieldNewPassword.becomeFirstResponder()    }
        if (textField == fieldNewPassword)      { fieldRetypePassword.becomeFirstResponder() }
        if (textField == fieldRetypePassword)   { actionDone()                               }

        return true
    }
}
