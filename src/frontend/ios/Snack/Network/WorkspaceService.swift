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
    
    func getWorkspace(method: HTTPMethod, accessToken: String, workspaceId: String = "", isChannels: Bool = false, isMembers: Bool = false, page: Int = 0, cell: deleteCellAction = deleteCellAction(index: -1, workspaceId: "")) -> Observable<NetworkResult<WorkspaceResponseModel>> {
        var url = APIConstants().workspaceList + "/\(workspaceId)"
        
        if isChannels { url += "/channels" }
        if isMembers { url += "/members" }
        if page != 0 { url += "?page=\(page)" }
        
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["X-AUTH-TOKEN": accessToken]
            let dataRequest = AF.request(url,
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
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<WorkspaceResponseModel> {
        let decoder = JSONDecoder()
        
//         데이터량이 너무 많음
//        if let JSONString = String(data: data, encoding: String.Encoding.utf8) { NSLog("Nework Response JSON : " + JSONString) }
        
        guard let decodedData = try? decoder.decode(WorkspaceResponseModel.self, from: data) else { return
                .pathErr
        }
        
        switch statusCode {
        case 200:
            if decodedData.code == "12000" {
                return .success(decodedData)
            } else if decodedData.code == "12001" { // 존재하지 않는 워크스페이스
                return .fail(decodedData)
            } else {
                return .fail(decodedData)
            }
        case 400: return .requestErr(decodedData)
        case 401: return .unAuthorized
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
