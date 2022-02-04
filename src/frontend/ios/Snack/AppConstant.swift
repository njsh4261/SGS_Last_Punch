//
//  AppConstant.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/27.
//

import Foundation

enum App {
    static let DefaultTab       = 0
    static let MaxVideoDuration = TimeInterval(10)
    static let TextShareApp     = "주소를 확인해주세요"
}

//enum MessageType {
//
//    static let Text             = "text"
//    static let Photo            = "photo"
//    static let Location         = "location"
//}

// 캐쉬
enum KeepMedia {

    static let Week             = 1
    static let Month            = 2
    static let Forever          = 3
}

// 미디어
enum Network {
    static let Manual           = 1
    static let WiFi             = 2
    static let All              = 3
}


enum MediaType {
    static let Photo            = 1
    static let Video            = 2
    static let Audio            = 3
}
