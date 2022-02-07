//
//  ExDateFormatter.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter.string(from: self)
    }
    
    func toString2() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd hh:mm"
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter.string(from: self)
    }
    
    func toTimeString() -> String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd kk:mm:ss"
        return formatter.date(from: self)
    }
    
    func toTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.date(from: self)
    }
}

