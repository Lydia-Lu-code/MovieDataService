//
//  Model.swift
//  CinemaAdmin
//
//  Created by Lydia Lu on 2024/12/25.
//

import Foundation

// MARK: - Model
struct MovieTicket: Codable, Equatable {
    var bookingDate: Date
    var movieName: String
    var showDate: Date
    var showTime: String
    var numberOfPeople: Int
    var ticketType: String
    var seatNumbers: String
    var totalAmount: Double
    
    // 客製化 CodingKeys 以對應 SheetDB 的欄位名稱
    enum CodingKeys: String, CodingKey {
        case bookingDate = "訂票日期"
        case movieName = "電影名稱"
        case showDate = "場次日期"
        case showTime = "場次時間"
        case numberOfPeople = "人數"
        case ticketType = "票種"
        case seatNumbers = "座位"
        case totalAmount = "總金額"
    }
    
    // 自定義解碼初始化器
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 日期格式轉換
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 解碼日期
        let bookingDateString = try container.decode(String.self, forKey: .bookingDate)
        guard let bookingDate = dateFormatter.date(from: bookingDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .bookingDate, in: container, debugDescription: "日期格式不正確")
        }
        self.bookingDate = bookingDate
        
        let showDateString = try container.decode(String.self, forKey: .showDate)
        guard let showDate = dateFormatter.date(from: showDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .showDate, in: container, debugDescription: "日期格式不正確")
        }
        self.showDate = showDate
        
        // 解碼其他欄位
        self.movieName = try container.decode(String.self, forKey: .movieName)
        self.showTime = try container.decode(String.self, forKey: .showTime)
        
        // 處理人數轉換
        let peopleString = try container.decode(String.self, forKey: .numberOfPeople)
        self.numberOfPeople = Int(peopleString) ?? 0
        
        self.ticketType = try container.decode(String.self, forKey: .ticketType)
        self.seatNumbers = try container.decode(String.self, forKey: .seatNumbers)
        
        // 處理總金額轉換
        let amountString = try container.decode(String.self, forKey: .totalAmount)
        self.totalAmount = Double(amountString) ?? 0
    }
    
    // 檢查相等性的靜態方法
    static func == (lhs: MovieTicket, rhs: MovieTicket) -> Bool {
        return lhs.bookingDate == rhs.bookingDate &&
               lhs.movieName == rhs.movieName &&
               lhs.showDate == rhs.showDate &&
               lhs.showTime == rhs.showTime &&
               lhs.numberOfPeople == rhs.numberOfPeople &&
               lhs.ticketType == rhs.ticketType &&
               lhs.seatNumbers == rhs.seatNumbers &&
               lhs.totalAmount == rhs.totalAmount
    }
}

//// MARK: - Model
//struct MovieTicket: Codable, Equatable {
//    var bookingDate: Date
//    var movieName: String
//    var showDate: Date
//    var showTime: String
//    var numberOfPeople: Int
//    var ticketType: String
//    var seatNumbers: String
//    var totalAmount: Double
//    
//    static func == (lhs: MovieTicket, rhs: MovieTicket) -> Bool {
//        return lhs.bookingDate == rhs.bookingDate &&
//               lhs.movieName == rhs.movieName &&
//               lhs.showDate == rhs.showDate &&
//               lhs.showTime == rhs.showTime &&
//               lhs.numberOfPeople == rhs.numberOfPeople &&
//               lhs.ticketType == rhs.ticketType &&
//               lhs.seatNumbers == rhs.seatNumbers &&
//               lhs.totalAmount == rhs.totalAmount
//    }
//}


