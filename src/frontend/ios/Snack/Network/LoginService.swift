//
//  LoginService.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import RxSwift
import Alamofire
import Foundation

//protocol LoginServiceProtocol {
//    func signIn(email: String, password: String) -> Observable<User>
//}

class LoginService {
    static let shared = LoginService()
    
    private func makeParameter(email : String, password : String) -> Parameters {
        return ["email" : email,
                "password" : password]
    }
    
    func signIn(email : String, password : String, completion : @escaping (NetworkResult<Any>) -> Void) {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        let dataRequest = AF.request(APIConstants().loginURL,
                                     method: .post,
                                     parameters: makeParameter(email: email, password: password),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.validate().responseData { [self] response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                let networkResult = judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure:
                completion(.pathErr)
            }
        }
    }
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(LoginDataModel.self, from: data)
        else { return .pathErr}
        
        switch statusCode {
        case 200:
            return .success(decodedData.data!)
        case 400: return .requestErr("errorCode : " + decodedData.code)
        case 401: return .unAuthorized
        case 404: return .notFound
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
