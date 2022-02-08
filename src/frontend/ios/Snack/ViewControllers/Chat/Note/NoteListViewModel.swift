//
//  NoteListViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
//

import RxSwift
import RxCocoa
import CoreGraphics
import Alamofire
import RxDataSources
import SwiftKeychainWrapper

class NoteListViewModel: ViewModelProtocol {
    
    struct Input {
        let channelId = PublishSubject<String>()
        let refresh = PublishSubject<Void>()
        let noteId = PublishSubject<String>()
        let btnAddTapped = PublishSubject<Void>()
        let noteListCellData = PublishSubject<[NoteListCellModel]>()
    }
    
    struct Output {
        let sections = PublishRelay<[SectionModel<NoteSection.NoteSection, NoteSection.NoteItem>]>()
        let refreshLoading = PublishRelay<Bool>()
        let successMessage = PublishRelay<String>()
        let errorMessage = PublishRelay<String>()
        let emptyMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private let networkGroup = DispatchGroup()
    var cellData: Driver<[NoteListCellModel]>
    var accessToken: String
    var channelId: String?
    
    // MARK: - Init
    init(workspaceId: String, _ channelId: String) {
        let userId: String = KeychainWrapper.standard[.id]!
        let accessToken: String = KeychainWrapper.standard[.refreshToken]!
        self.channelId = channelId
        self.cellData = input.noteListCellData
            .asDriver(onErrorJustReturn: [])
        self.accessToken = accessToken
        
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
        
        // Add Note
        input.btnAddTapped
            .bind { [weak self] in
                guard let self = self else { return }
                self.networkGroup.enter()
                self.getNote(method: .post, accessToken: accessToken, workspaceId: workspaceId, channelId: channelId, creatorId: userId, isCreate: true)
                self.networkGroup.notify(queue: .main) { [self] in
                    self.getNoteList()
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
    
    // delete Note
    func deleteNote(noteId: String) {
        self.networkGroup.enter()
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            self.getNote(method: .delete, accessToken: accessToken, noteId: noteId, isDelete: true)
        }
        self.networkGroup.notify(queue: .main) { [self] in
            self.getNoteList()
        }
    }
    
    func getNote(method: HTTPMethod, accessToken: String, workspaceId: String = "", channelId: String = "", creatorId: String = "", noteId: String = "", isCreate: Bool = false, isDelete: Bool = false) {
        NoteService.shared.getNote(method: method, accessToken: accessToken, workspaceId: workspaceId, channelId: channelId, creatorId: creatorId, noteId: noteId, isCreate: isCreate, isDelete: isDelete)
            .observe(on: MainScheduler.instance)
            .subscribe{ [self] event in
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let decodedData):
                        switch method {
                        case .post:
                            self.output.successMessage.accept("추가되었습니다")
                            self.networkGroup.leave()
                        case .get:
                            guard let noteList = decodedData.data?.noteList else {
                                self.output.errorMessage.accept("노트 목록을 불러오지 못했습니다")
                                return
                            }
                            if noteList.isEmpty { self.output.emptyMessage.accept("노트 목록이 비어있습니다") }
                            let sectionNoteList = self.getNoteList(noteList)
                            let noteItems = sectionNoteList.map(NoteSection.NoteItem.note)
                            let noteSection = NoteSection.Model(model: .note, items: noteItems)
                            output.sections.accept([noteSection])
                        case .delete:
                            self.output.successMessage.accept("삭제되었습니다")
                            self.networkGroup.leave()
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
        
    func getNoteList(_ notelist: [NoteListCellModel]) -> [Note] {
        return notelist.map {
            Note(
                id: $0.id,
                title: $0.title,
                creatorId: $0.creatorId,
                createDt: $0.createDt,
                modifyDt: $0.modifyDt)
        }
    }    
}
