//
//  ViewModelProtocol.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import Foundation

// ViewModel의 기본 포멧
// Input : 입력 이벤트를 내보내는 UI 요소를 구독해야 하는 observers(예: AnyObserver)가 포함되어야 합니다.
// Output : 입력 처리 결과와 관련된 이벤트를 내보내는 observables이 포함되어야 합니다.

protocol ViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
}
