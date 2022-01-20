////
////  ProfileViewModel.swift
////  Snack
////
////  Created by ghyeongkim-MN on 2022/01/17.
////
//
//import RxSwift
//import RxCocoa
//
//class ProfileViewModel: ViewModelProtocol {
//    struct Input {
//        let titleTextFieldCellViewModel = EditProfileViewModel()
//    }
//    
//    struct Output {
////        let registerResultObservable: Observable<User>
////        let errorsObservable: Observable<Error>
//    }
//    // MARK: - Public properties
//    var input = Input()
//    var output = Output()
//    
//    // MARK: - Private properties
//    let cellData: Driver<[String]>
//
////    private let emailSubject = PublishSubject<String>()
////    private let passwofrdSubject = PublishSubject<String>()
////    private let signUpDidTapSubject = PublishSubject<Void>()
////    private let registerResultSubject = PublishSubject<User>()
////    private let errorsSubject = PublishSubject<Error>()
//    private let disposeBag = DisposeBag()
//    
//    // MARK: - Init
//    init() {
//        let editProfileViewModel = EditProfileViewModel()
//        let editProfile = editProfileViewModel
//            .selectedEditProfile
//            .map { $0.name }
//            .startWith("프로필 편집")
//        let title1 = Observable.just("비밀번호 변경")
//        let title2 = Observable.just("상태변경")
//        let title3 = Observable.just("바쁨")
//        let title4 = Observable.just("캐쉬 설정")
//        let title5 = Observable.just("미디어 설정")
//        let title6 = Observable.just("로그아웃")
//        let title7 = Observable.just("탈퇴")
//        
//        self.cellData = Observable
//            .combineLatest(
//                editProfile,
//                title1,
//                title2,
//                title3,
//                title4,
//                title5,
//                title6,
//                title7
//            ) { [$0, $1, $2, $3, $4, $5, $6, $7] }
//            .asDriver(onErrorDriveWith: .empty())
//    }
//}
