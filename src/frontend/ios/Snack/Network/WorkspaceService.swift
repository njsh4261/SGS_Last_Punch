//
//  WorkspaceService.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/23.
//

import RxSwift
import Alamofire

class WorkspaceService {
    static let shared = WorkspaceService()
    
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
    
    func getWorkspace(userId : String) -> Observable<NetworkResult<Any>> {
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["userId": userId]
            let dataRequest = AF.request(APIConstants().workspaceList,
                                         method: .get,
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
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
                
        if let JSONString = String(data: data, encoding: String.Encoding.utf8) { NSLog("Nework Response JSON : " + JSONString) }
        
        guard let decodedData = try? decoder.decode(RegisterDataModel.self, from: data) else { return
            .pathErr
        }
        
        switch statusCode {
        case 200:
            if decodedData.code == "11000" {
                return .success(decodedData.code)
            } else if decodedData.code == "11001" { // 이미 가입된 이메일이 있을때
                return .fail(decodedData.code)
            } else if decodedData.code == "11003" { // 이메일 인증 코드가 유효하지 않을때
                return .fail(decodedData.code)
            } else if decodedData.code == "11004" { // 이메일 인증시 사용했던 데이터가 변조되었을때
                return .fail(decodedData.code)
            } else {
                return .serverErr
            }
        case 400: return .requestErr("errorCode : " + decodedData.code)
        case 401: return .unAuthorized
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
