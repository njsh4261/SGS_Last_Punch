import UIKit
import RxSwift

print("-------just-------")
Observable.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("-------of1-------")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })

print("-------of2-------")
Observable.of([1, 2, 3])
    .subscribe(onNext: {
        print($0)
    })

print("-------from-------")
Observable.from([1, 2, 3])
    .subscribe(onNext: {
        print($0)
    })
    .dispose()

print("-------subscribe1-------")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }

print("-------subscribe2-------")
Observable.of(1, 2, 3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

print("-------subscribe3-------")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })

print("-------empty-------")
Observable.empty()
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("Completed")
        })

print("-------never-------")
Observable.never()
//    .debug("never")
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("Completed")
        })

print("------range------")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2*\($0)=\(2*$0)")
    })

print("------dispose------")
Observable.of(1, 2, 3)
    .subscribe({
        print($0)
    })
    .dispose()

print("------disposeBag------")
let disposeBag = DisposeBag()
Observable.of(1, 2, 3)
    .subscribe({
        print($0)
    })
    .disposed(by: disposeBag)

print("------create1------")
Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(onNext: {
    print($0)
}, onError: {
    print($0)
}, onCompleted: {
    print("completed")
}, onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)
    
print("------create2------")
enum Errors: Error {
    case criticalError
}
Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(Errors.criticalError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(onNext: {
    print($0)
}, onError: {
    print($0)
}, onCompleted: {
    print("completed")
}, onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)
    
print("------create3------")
Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(onNext: {
    print($0)
}, onError: {
    print($0)
}, onCompleted: {
    print("completed")
}, onDisposed: {
    print("disposed")
})

print("------deffered------")
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)


print("------deffered2------")
var 뒤집기 = false

let factory: Observable<String> = Observable.deferred({
    뒤집기 = !뒤집기
    
    if 뒤집기 {
        return Observable.of("👍")
    } else {
        return Observable.of("👎")
    }
})

for _ in 0...3 {
    factory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}

print("------single------")
struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name":"hello"}
"""

let json2 = """
    {"my_name":"hello"}
"""

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer in
        let disposable = Disposables.create()
        
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {
            
            observer(.failure(JSONError.decodingError))
            return disposable
        }
        
        observer(.success(json))
        return disposable
    }
}

decode(json: json1)
    .subscribe{
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe{
        switch $0 {
        case .success(let json):
            print(json)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
