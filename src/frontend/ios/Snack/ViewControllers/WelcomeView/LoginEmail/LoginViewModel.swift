//
//  LoginViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import RxSwift

class LoginViewModel: ViewModelProtocol {
    struct Input {
        let email: AnyObserver<String>
        let password: AnyObserver<String>
        let signInDidTap: AnyObserver<Void>
    }
    
    struct Output {
        let loginResultObservable: Observable<User>
        let errorsObservable: Observable<Error>
    }
    // MARK: - Public properties
    let input: Input
    let output: Output
    
    // MARK: - Private properties
    private let emailSubject = PublishSubject<String>()
    private let passwordSubject = PublishSubject<String>()
    private let signInDidTapSubject = PublishSubject<Void>()
    private let loginResultSubject = PublishSubject<User>()
    private let errorsSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    
    private var credentialsObservable: Observable<Credentials> {
        return Observable.combineLatest(emailSubject.asObservable(), passwordSubject.asObservable()) { (email, password) in
            return Credentials(email: email, password: password)
        }
    }
    
    // MARK: - Init
    init(_ loginService: LoginServiceProtocol) {
        
        input = Input(email: emailSubject.asObserver(),
                      password: passwordSubject.asObserver(),
                      signInDidTap: signInDidTapSubject.asObserver())
        
        output = Output(loginResultObservable: loginResultSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable())
                
        signInDidTapSubject
            .withLatestFrom(credentialsObservable)
            .flatMapLatest { credentials in
                return loginService.signIn(with: credentials).materialize()
            }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let user):
                    self?.loginResultSubject.onNext(user)
                case .error(let error):
                    self?.errorsSubject.onNext(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(emailSubject.asObserver(), passwordSubject.asObserver()).map {
            (email, password) in
            return email.count > 3 && password.count > 3
        }
    }
}
