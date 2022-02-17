//
//  ChannelService.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/14.
//

import RxSwift
import Alamofire

class ChannelService {
    static let shared = ChannelService()
    
    private func makeParameter(workspaceId: Int, name: String, description: String) -> Parameters {
        return [
            "workspaceId": workspaceId,
            "name" : name,
            "description" : description
        ]
    }
    
    func getChannel(method: HTTPMethod, _ accessToken: String, channelId: String) -> Observable<NetworkResult<ChannelResponseModel>> {
        let url = APIConstants().channelURL + "/\(channelId)"
                
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
    
    func getMember(method: HTTPMethod, _ accessToken: String, channelId: String) -> Observable<NetworkResult<ChannelResponseModel>> {
        let url = APIConstants().channelURL + "/\(channelId)/members"
                
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
    
    func addChannelURL(method: HTTPMethod, accessToken: String, workspaceId: Int, name: String, description: String) -> Observable<NetworkResult<ChannelResponseModel>> {
        let url = APIConstants().channelURL
        let parameters = self.makeParameter(workspaceId: workspaceId, name: name, description: description)
                
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
    
    func addMember(method: HTTPMethod, accessToken: String, body: Parameters) -> Observable<NetworkResult<ChannelResponseModel>> {
        let url = APIConstants().channelURL + "/member"
                        
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["X-AUTH-TOKEN": accessToken]
            let dataRequest = AF.request(url,
                                         method: method,
                                         parameters: body,
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

    
    func editChannel(method: HTTPMethod, accessToken: String, channelId: String, name: String, description: String) -> Observable<NetworkResult<ChannelResponseModel>> {
        let url = APIConstants().channelURL + "/\(channelId)"
                
        return Observable.create { observer -> Disposable in
            let header : HTTPHeaders = ["X-AUTH-TOKEN": accessToken]
            let dataRequest = AF.request(url,
                                         method: method,
                                         parameters: ["description": description],
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

    func deleteChannel(method: HTTPMethod, accessToken: String, channelId: String) -> Observable<NetworkResult<ChannelResponseModel>> {
        let url = APIConstants().channelURL + "/\(channelId)"
                
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
    
    func deleteMember(method: HTTPMethod, accessToken: String, accountId: String,  channelId: String) -> Observable<NetworkResult<ChannelResponseModel>> {
        let url = APIConstants().channelURL + "/member?accountId=\(accountId)&channelId=\(channelId)"
                
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

    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<ChannelResponseModel> {
        let decoder = JSONDecoder()
        
//         데이터량이 너무 많음
//        if let JSONString = String(data: data, encoding: String.Encoding.utf8) { NSLog("Nework Response JSON : " + JSONString) }
        
        guard let decodedData = try? decoder.decode(ChannelResponseModel.self, from: data) else {
            return .pathErr
        }
        
        switch statusCode {
        case 200:
            if decodedData.code == "12000" {
                return .success(decodedData)
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
