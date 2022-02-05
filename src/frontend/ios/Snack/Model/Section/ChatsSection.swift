//
//  ChatsSection.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

//import RxDataSources
//
//enum ChatsSection {
//    case SectionOne(items: [SectionItem])
//    case SectionTwo(items: [SectionItem])
//}
//
//enum SectionItem {
//    case StatusChannel(header: String, items: [ChannelObject])
//    case StatusDirectMessage(header: String, items: [MemberListCellModel])
//}
//
//extension ChatsSection: SectionModelType {
//    typealias Item = SectionItem
//    
//    var items: [SectionItem] {
//          switch self {
//          case .SectionOne(items: let items):
//              return items.map { $0 }
//          case .SectionTwo(items: let items):
//              return items.map { $0 }
//          }
//      }
//    
//    init(original: ChatsSection, items: [SectionItem]) {
//        switch original {
//        case .SectionOne(items: _):
//            self = .SectionOne(items: items)
//        case .SectionTwo(items: _):
//            self = .SectionTwo(items: items)
//        }
//    }
//}
