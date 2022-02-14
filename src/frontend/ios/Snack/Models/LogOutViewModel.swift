//
//  LogOut.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/25.
//

import UIKit
import SwiftKeychainWrapper
import RxSwift
import RxCocoa
import ProgressHUD
import PasscodeKit

class LogOutViewModel {
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    init(viewContoller: UIViewController) {
        guard let token: String = KeychainWrapper.standard[.accessToken] else { return }
        
        ProgressHUD.show(nil, interaction: false)
        logOutService(viewContoller: viewContoller, token: token)
        PasscodeKit.remove()
        StompWebsocket.shared.disconnect()
    }
    
    // keyChain 정보 삭제
    func deleteKeyChainData() {
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.email.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.refreshToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.workspaceId.rawValue)
    }
    
    func logOutService(viewContoller: UIViewController, token: String) {
        LoginService.shared.logOut(method: .get, refreshToken: token)
            .subscribe { event in
                switch event {
                case .next(let result):
                    let when = DispatchTime.now() + 1.0
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        switch result {
                        case .success:
                            viewContoller.dismiss(animated: true) {
                                self.deleteKeyChainData()
                                ProgressHUD.dismiss()
                            }
                        default:
                            ProgressHUD.showFailed("로그아웃 실패")
                        }
                    }
                    break
                default:
                    ProgressHUD.showFailed("서버 문제 발생")
                }
            }.disposed(by: self.disposeBag)
    }
}
