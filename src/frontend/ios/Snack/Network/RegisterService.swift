//
//  RegisterService.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import RxSwift
import Alamofire

class RegisterService {
    static let shared = RegisterService()
    
    private func makeSendEmailParameter(email: String) -> Parameters {
        return ["email": email]
    }
    
    private func makeVerifyParameter(email: String, code: String) -> Parameters {
        return ["email": email,
                "verifyCode": code]
    }
    
    private func makeSignUpParameter(email: String, code: String, password: String) -> Parameters {
        return ["email": email,
                "password": password,
                "verifyCode": code]
    }
    
    func sendEmail(email : String) -> Observable<NetworkResult<Any>> {
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["Content-Type": "application/json"]
            let dataRequest = AF.request(APIConstants().authEmailURL,
                                         method: .post,
                                         parameters: self.makeSendEmailParameter(email: email),
                                         encoding: JSONEncoding.default,
                                         headers: header)
            
            dataRequest.validate().responseData { [self] response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    let networkResult = judgeStatus(by: statusCode, value)
                    return observer.onNext(networkResult)
                case .failure:
                    return observer.onNext(.pathErr)
                }
            }
            return Disposables.create()
        }
    }
    
    func verify(email: String, code: String) -> Observable<NetworkResult<Any>> {
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["Content-Type": "application/json"]
            let dataRequest = AF.request(APIConstants().authEmailURL,
                                         method: .get,
                                         parameters: self.makeVerifyParameter(email: email, code: code),
                                         encoding: JSONEncoding.default,
                                         headers: header)
            
            dataRequest.validate().responseData { [self] response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    let networkResult = judgeStatus(by: statusCode, value)
                    return observer.onNext(networkResult)
                case .failure:
                    return observer.onNext(.pathErr)
                }
            }
            return Disposables.create()
        }
    }
    
    func signUp(email: String, code: String, password:String) -> Observable<NetworkResult<Any>> {
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["Content-Type": "application/json"]
            let dataRequest = AF.request(APIConstants().signUpURL,
                                         method: .post,
                                         parameters: self.makeSignUpParameter(email: email, code: code, password: password),
                                         encoding: JSONEncoding.default,
                                         headers: header)
            
            dataRequest.validate().responseData { [self] response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else {return}
                    guard let value = response.value else {return}
                    let networkResult = judgeStatus(by: statusCode, value)
                    return observer.onNext(networkResult)
                case .failure:
                    return observer.onNext(.pathErr)
                }
            }
            return Disposables.create()
        }
    }
}
