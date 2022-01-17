//
//  ChatsViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import RxSwift
import RxCocoa

class ChatsViewModel: ViewModelProtocol {
    struct Input {
//        let email: AnyObserver<String>
//        let password: AnyObserver<String>
//        let signUpDidTap: AnyObserver<Void>
//        let cellData: Driver<[String]>
    }
    
    struct Output {
//        let registerResultObservable: Observable<User>
//        let errorsObservable: Observable<Error>
    }
    // MARK: - Public properties
    let input: Input
    let output: Output
    
    // MARK: - Private properties
//    private let emailSubject = PublishSubject<String>()
//    private let passwordSubject = PublishSubject<String>()
//    private let signUpDidTapSubject = PublishSubject<Void>()
//    private let registerResultSubject = PublishSubject<User>()
//    private let errorsSubject = PublishSubject<Error>()
//    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(_ ChatsService: RegisterServiceProtocol) {
        let title = Observable.just("글 제목")
        input = Input()

        output = Output()

//        signUpDidTapSubject
//            .withLatestFrom(credentialsObservable)
//            .flatMapLatest { credentials in
//                return registerService.signUp(with: credentials).materialize()
//            }
//            .subscribe(onNext: { [weak self] event in
//                switch event {
//                case .next(let user):
//                    self?.registerResultSubject.onNext(user)
//                case .error(let error):
//                    self?.errorsSubject.onNext(error)
//                default:
//                    break
//                }
//            })
//            .disposed(by: disposeBag)
        
    }
    func test() {
        guard let jsonData = load(),
              let sodeul = try? JSONDecoder().decode(ChannelList.self, from: jsonData) else {
                  return
              }
//        channelObjects = sodeul.channels
    }

    func load() -> Data?{
        let fileNm: String = "Channel"
        let extensionType = "json"
        
        
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
}