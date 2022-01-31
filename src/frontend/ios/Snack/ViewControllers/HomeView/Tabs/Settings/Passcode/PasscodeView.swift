//
//  PasscodeView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/01.
//

import UIKit
import PasscodeKit

class PasscodeView: UIViewController {

    @IBOutlet private var tableView: UITableView!

    @IBOutlet private var cellTurnPasscode: UITableViewCell!
    @IBOutlet private var cellChangePasscode: UITableViewCell!
    @IBOutlet private var cellBiometric: UITableViewCell!

    @IBOutlet private var switchBiometric: UISwitch!

    override func viewDidLoad() {

        super.viewDidLoad()
        title = "패스코드"

        switchBiometric.addTarget(self, action: #selector(actionBiometric), for: .valueChanged)
        settingPasscodeKit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateViewDetails()
    }
    
    // MARK: - PasscodeKit Settings
    func settingPasscodeKit() {
        PasscodeKit.backgroundColor = .systemBackground
        PasscodeKit.textColor = .label
        
        PasscodeKit.titleEnterPasscode = "암호 입력"
        PasscodeKit.titleCreatePasscode = "암호 생성"
        PasscodeKit.titleChangePasscode = "암호 변경"
        PasscodeKit.titleRemovePasscode = "암호 해제"
        
        PasscodeKit.textEnterPasscode = "암호를 입력해주세요"
        PasscodeKit.textVerifyPasscode = "암호를 다시 입략해주세요"
        PasscodeKit.textEnterOldPasscode = "이전 암호를 입력해주세요"
        PasscodeKit.textEnterNewPasscode = "새 암호를 입력해주세요"
        PasscodeKit.textVerifyNewPasscode = "새 암호를 다시 입력해주세요"
        PasscodeKit.textFailedPasscode = "%d회 다시 시도해주세요"
        PasscodeKit.textPasscodeMismatch = "암호가 일치하지 않습니다. 다시 시도해주세요"
        PasscodeKit.textTouchIDAccessReason = "Touch ID를 사용하여 앱 잠금을 해제해주세요"
    }

    // MARK: - User actions
    func actionTurnPasscode() {

        if (PasscodeKit.enabled()) {
            PasscodeKit.removePasscode(self)
        } else {
            PasscodeKit.createPasscode(self)
        }
    }

    func actionChangePasscode() {

        if (PasscodeKit.enabled()) {
            PasscodeKit.changePasscode(self)
        }
    }

    @objc func actionBiometric() {

        PasscodeKit.biometric(switchBiometric.isOn)
    }

    // MARK: - Helper methods
    func updateViewDetails() {

        if (PasscodeKit.enabled()) {
            cellTurnPasscode.textLabel?.text = "암호 끄기"
            cellChangePasscode.textLabel?.textColor = UIColor(named: "snackColor")
        } else {
            cellTurnPasscode.textLabel?.text = "암호 켜기"
            cellChangePasscode.textLabel?.textColor = UIColor.lightGray
        }

        switchBiometric.isOn = PasscodeKit.biometric()

        tableView.reloadData()
    }
}

// MARK: - UITableView DataSource
extension PasscodeView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return PasscodeKit.enabled() ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (section == 0) { return 2 }
        if (section == 1) { return 1 }

        return 0
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        if (section == 1) { return "Face ID(또는 Touch ID)를 사용하여 앱 잠금을 해제하도록 허용합니다" }

        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellTurnPasscode    }
        if (indexPath.section == 0) && (indexPath.row == 1) { return cellChangePasscode    }
        if (indexPath.section == 1) && (indexPath.row == 0) { return cellBiometric        }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension PasscodeView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.section == 0) && (indexPath.row == 0) { actionTurnPasscode()        }
        if (indexPath.section == 0) && (indexPath.row == 1) { actionChangePasscode()    }
    }
}
