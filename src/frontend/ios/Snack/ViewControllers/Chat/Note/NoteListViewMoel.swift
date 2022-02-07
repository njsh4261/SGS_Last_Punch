//
//  NoteListViewMoel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
//

import RxSwift
import RxCocoa
import CoreGraphics
import Alamofire
import SwiftKeychainWrapper

class NoteListViewMoel: ViewModelProtocol {
    
    struct Input {
        let channelId = PublishSubject<String>()
        let refresh = PublishSubject<Void>()
        let noteListCellData = PublishSubject<[NoteListCellModel]>()
    }
    
    struct Output {
        let refreshLoading = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        let emptyMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    var cellData: Driver<[NoteListCellModel]>
    var accessToken: String
    var channelId: String?
    
    // MARK: - Init
    init(_ channelId: String) {
        let accessToken: String = KeychainWrapper.standard[.refreshToken]!
        self.accessToken = accessToken
        self.channelId = channelId
        self.cellData = input.noteListCellData
            .asDriver(onErrorJustReturn: [])
                
        // refresh
        input.refresh
            .bind { [weak self] in
                guard let self = self else { return }
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.getNote(method: .get, accessToken: accessToken, channelId: channelId)
                    self.output.refreshLoading.accept(false)
                }
            }.disposed(by: disposeBag)
    }
    
    // init - Cell Data
    func getNoteList() {
        guard let channelId = channelId else { return }
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            self.getNote(method: .get, accessToken: accessToken, channelId: channelId)
        }
    }
    
    func getNote(method: HTTPMethod, accessToken: String, workspaceId: String = "", channelId: String, creatorId: String = "", isCreate: Bool = false) {
        NoteService.shared.getNote(method: method, accessToken: accessToken, workspaceId: workspaceId, channelId: channelId, creatorId: creatorId, isCreate: isCreate)
            .observe(on: MainScheduler.instance)
            .subscribe{ event in
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let decodedData):
                        switch method {
                        case .get:
                            guard let noteList = decodedData.data?.noteList else {
                                self.output.errorMessage.accept("노트 목록을 불러오지 못했습니다")
                                return
                            }
                            if noteList.isEmpty { self.output.emptyMessage.accept("노트 목록이 비어있습니다") }
                            self.input.noteListCellData.onNext(noteList)
                        default:
                            break
                        }
                    default:
                        self.output.errorMessage.accept("문제가 발생했어요")
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
}
