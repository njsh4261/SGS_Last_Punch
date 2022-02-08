//
//  NoteService.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
//

import RxSwift
import Alamofire

class NoteService {
    static let shared = NoteService()
    
    private func makeParameter(workspaceId: Int, channelId : Int, creatorId: Int) -> Parameters {
        return ["workspaceId" : workspaceId,
                "channelId": channelId,
                "creatorId": creatorId
        ]
    }
    
    func getNote(method: HTTPMethod, accessToken: String, workspaceId: String = "", channelId: String, creatorId: String = "", noteId: String = "", isCreate: Bool = false, isDelete: Bool = false) -> Observable<NetworkResult<NoteResponseModel>> {
        var url: String = ""
        var parameters: Parameters? = nil
        
        if isCreate {
            url = APIConstants().noteListURL
            parameters = self.makeParameter(workspaceId: Int(workspaceId)!, channelId: Int(channelId)!, creatorId: Int(creatorId)!)
        } else {
            if isDelete {
                url = APIConstants().noteListURL + "/\(noteId)"
            } else {
                url = APIConstants().noteListURL + "s?channelId=\(channelId)"
            }
        }
        
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["X-AUTH-TOKEN": accessToken]
            let dataRequest = AF.request(url,
                                         method: method,
                                         parameters: parameters,
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
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<NoteResponseModel> {
        let decoder = JSONDecoder()
        
        // 데이터량이 너무 많음
//        if let JSONString = String(data: data, encoding: String.Encoding.utf8) { NSLog("Nework Response JSON : " + JSONString) }
        
        guard let decodedData = try? decoder.decode(NoteResponseModel.self, from: data) else { return
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
