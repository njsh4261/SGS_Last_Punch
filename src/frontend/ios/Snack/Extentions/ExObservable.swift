//
//  ExObservable.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import RxSwift

public protocol OptionalType {
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

// 컴파일에서 이해할 수 없는 오류 방지
extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}
