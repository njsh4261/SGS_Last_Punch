//
//  PresenceService.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/19.
//

import RxSwift
import Alamofire

class PresenceService {
    static let shared = PresenceService()
    
    // 워크스페이스 사용자 상태
    func getPresenceList(method: HTTPMethod, accessToken: String, workspaceId: String) -> Observable<NetworkResult<PresenceResponseModel>> {
        let url = APIConstants().presenceURL + "/\(workspaceId)"

        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["X-AUTH-TOKEN": accessToken]
            let dataRequest = AF.request(url,
                                         method: method,
                                         parameters: nil,
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
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<PresenceResponseModel> {
        let decoder = JSONDecoder()
        
        // 데이터량이 너무 많음
        if let JSONString = String(data: data, encoding: String.Encoding.utf8) { NSLog("Nework Response JSON : " + JSONString) }
        
        guard let decodedData = try? decoder.decode(PresenceResponseModel.self, from: data) else { return
                .pathErr
        }
        
        switch statusCode {
        case 200: return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 401: return .unAuthorized
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
