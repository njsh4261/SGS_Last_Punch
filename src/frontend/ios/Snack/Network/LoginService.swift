//
//  LoginService.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import RxSwift
import Alamofire

class LoginService {
    static let shared = LoginService()
    
    private func makeParameter(email : String, password : String) -> Parameters {
        return ["email" : email,
                "password" : password]
    }
    
    func logIn(email : String, password : String) -> Observable<NetworkResult<Any>> {
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["Content-Type": "application/json"]
            let dataRequest = AF.request(APIConstants().loginURL,
                                         method: .post,
                                         parameters: self.makeParameter(email: email, password: password),
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
    
    func logOut(method: HTTPMethod, refreshToken : String) -> Observable<NetworkResult<Any>> {
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["X-AUTH-TOKEN": refreshToken]
            let dataRequest = AF.request(APIConstants().logoutURL,
                                         method: method,
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
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        if let JSONString = String(data: data, encoding: String.Encoding.utf8) { NSLog("Nework Response JSON : " + JSONString) }
        
        guard let decodedData = try? decoder.decode(LoginDataModel.self, from: data)
        else { return .pathErr}
        
        switch statusCode {
        case 200:
            if decodedData.code == "11000" {
                return .success(decodedData)
            } else { // 이메일, 비밀번호를 일치하지 않을때,
                return .fail(decodedData.code)
            }
        case 400: return .requestErr(decodedData.code)
        case 401: return .unAuthorized
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}


