//
//  RegisterService.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import Foundation
import RxSwift

protocol RegisterServiceProtocol {
    func signUp(with credentials: Credentials) -> Observable<User>
}

class RegisterService: RegisterServiceProtocol {
    func signUp(with credentials: Credentials) -> Observable<User> {
        return Observable.create { observer in
            /*
             Networking logic here.
            */
            observer.onNext(User()) // Simulation of successful user authentication.
            return Disposables.create()
        }
    }
}
