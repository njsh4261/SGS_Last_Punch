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

class EditProfileView: UIViewController {
    // MARK: - Properties
    private var userInfo: UserModel?
    private var selectImage: Int?

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
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, userInfo: UserModel) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.userInfo = userInfo
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
        lblInitials.text = userInfo?.name.first?.description
        fieldName.text = userInfo?.name
        fieldDescription.text = userInfo?.description
        lblCountry.text = userInfo?.country == "kor" ? "대한민국" : "해외"
        fieldPhone.text = userInfo?.phone

        lblPlaceholder.isHidden = (lblCountry.text != "")
    }

    @objc func actionDismiss() {
        dismiss(animated: true)
    }
    
    @objc func actionSave() {

        let name = fieldName.text ?? ""
        let country = lblCountry.text ?? ""

        if (name.isEmpty)           { ProgressHUD.showFailed("이름은 반드시 작성해야합니다");        return  }
        if (country.isEmpty)        { ProgressHUD.showFailed("국적은 반드시 작성해야합니다");        return  }

        ProgressHUD.showSucceed("변경되었습니다")
        dismiss(animated: true)
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
    
    // MARK: - Upload methods
    func uploadPicture(image: UIImage) {

        ProgressHUD.show(nil, interaction: false)

        let squared = image.square(to: 300)
        if let data = squared.jpegData(compressionQuality: 0.6) {
            if let _ = Cryptor.encrypt(data: data) {
                self.pictureUploaded(image: squared, data: data)

            }
        }
    }
    
    func pictureUploaded(image: UIImage, data: Data) {
        ivUser.image = image.square(to: 70)
        lblInitials.text = nil

        ProgressHUD.dismiss()
    }
}

// MARK: - UIImage PickerController Delegate
extension EditProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[.editedImage] as? UIImage {
            uploadPicture(image: image)
        }
        picker.dismiss(animated: true)
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

