//
//  ChatService.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/16.
//

import RxSwift
import Alamofire

class ChatService {
    static let shared = ChatService()
    
    private func makeParameter(channelId: String, dateTime: String) -> Parameters {
        return ["channelId" : channelId,
                "dateTime" : dateTime]
    }
    
    // 최근 메시지
    func getRecent(method: HTTPMethod, accessToken: String, channelId: String) -> Observable<NetworkResult<ChatResponseModel>> {
        let url = APIConstants().chatURL + "/recent"

        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["X-AUTH-TOKEN": accessToken]
            let dataRequest = AF.request(url,
                                         method: method,
                                         parameters: ["channelId": channelId],
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
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<ChatResponseModel> {
        let decoder = JSONDecoder()
        
        // 데이터량이 너무 많음
//        if let JSONString = String(data: data, encoding: String.Encoding.utf8) { NSLog("Nework Response JSON : " + JSONString) }
        
        guard let decodedData = try? decoder.decode(ChatResponseModel.self, from: data) else { return
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
