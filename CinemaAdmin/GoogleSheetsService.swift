import Foundation

protocol MovieTicketServiceProtocol {
    func fetchTickets() async throws -> [MovieTicket]
    func updateTicket(_ ticket: MovieTicket) async throws
    func deleteTicket(_ ticket: MovieTicket) async throws
}

class GoogleSheetsService: MovieTicketServiceProtocol {
    // SheetDB API 端點
    private let apiEndpoint = "https://sheetdb.io/api/v1/gwog7qdzdkusm"
    
    func fetchTickets() async throws -> [MovieTicket] {
        return try await withCheckedThrowingContinuation { continuation in
            NetworkService.shared.get(urlString: apiEndpoint) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        
                        let tickets = try decoder.decode([MovieTicket].self, from: data)
                        continuation.resume(returning: tickets)
                    } catch {
                        print("❌ 解碼錯誤: \(error)")
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("❌ 網路請求錯誤: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func updateTicket(_ ticket: MovieTicket) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // 將 ticket 轉換為字典，準備發送
            let parameters: [String: Any] = [
                "訂票日期": formatDate(ticket.bookingDate),
                "電影名稱": ticket.movieName,
                "場次日期": formatDate(ticket.showDate),
                "場次時間": ticket.showTime,
                "人數": ticket.numberOfPeople,
                "票種": ticket.ticketType,
                "座位": ticket.seatNumbers,
                "總金額": ticket.totalAmount
            ]
            
            NetworkService.shared.post(urlString: apiEndpoint, body: parameters) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func deleteTicket(_ ticket: MovieTicket) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // 根據 SheetDB 的實際 API 設計調整刪除邏輯
            let deleteEndpoint = "\(apiEndpoint)/電影名稱/\(ticket.movieName)"
            
            NetworkService.shared.get(urlString: deleteEndpoint) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // 日期格式化輔助方法
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
}

//import Foundation
//
//protocol MovieTicketServiceProtocol {
//    func fetchTickets() async throws -> [MovieTicket]
//    func updateTicket(_ ticket: MovieTicket) async throws
//    func deleteTicket(_ ticket: MovieTicket) async throws
//}
//
//class GoogleSheetsService: MovieTicketServiceProtocol {
//    // SheetDB API 端點 (使用您的實際端點)
//    private let apiEndpoint = "https://sheetdb.io/api/v1/gwog7qdzdkusm"
//    
//    func fetchTickets() async throws -> [MovieTicket] {
//        return try await withCheckedThrowingContinuation { continuation in
//            NetworkService.shared.get(urlString: apiEndpoint) { result in
//                switch result {
//                case .success(let data):
//                    do {
//                        let decoder = JSONDecoder()
//                        
//                        // 設定日期解碼策略
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//                        
//                        let tickets = try decoder.decode([MovieTicket].self, from: data)
//                        continuation.resume(returning: tickets)
//                    } catch {
//                        continuation.resume(throwing: NetworkError.decodingError)
//                    }
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
//    
//    func updateTicket(_ ticket: MovieTicket) async throws {
//        return try await withCheckedThrowingContinuation { continuation in
//            // 將 ticket 轉換為字典，準備發送
//            let parameters: [String: Any] = [
//                "movieName": ticket.movieName,
//                "showDate": ticket.showDate,
//                "showTime": ticket.showTime,
//                "numberOfPeople": ticket.numberOfPeople,
//                "ticketType": ticket.ticketType,
//                "seatNumbers": ticket.seatNumbers,
//                "totalAmount": ticket.totalAmount
//            ]
//            
//            NetworkService.shared.post(urlString: apiEndpoint, body: parameters) { result in
//                switch result {
//                case .success:
//                    continuation.resume()
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
//    
//    func deleteTicket(_ ticket: MovieTicket) async throws {
//        return try await withCheckedThrowingContinuation { continuation in
//            // 根據 SheetDB 的實際 API 設計調整刪除邏輯
//            let deleteEndpoint = "\(apiEndpoint)/movieName/\(ticket.movieName)"
//            
//            NetworkService.shared.get(urlString: deleteEndpoint) { result in
//                switch result {
//                case .success:
//                    continuation.resume()
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
//}
//
//////
//////  MockData.swift
//////  CinemaAdmin
//////
//////  Created by Lydia Lu on 2024/12/25.
//////
////
////import Foundation
////
////protocol MovieTicketServiceProtocol {
////    func fetchTickets() async throws -> [MovieTicket]
////    func updateTicket(_ ticket: MovieTicket) async throws
////    func deleteTicket(_ ticket: MovieTicket) async throws
////}
////
////struct MockData {
////    static let testTickets = [
////        MovieTicket(
////            bookingDate: Date(),
////            movieName: "蜘蛛人3",
////            showDate: Date(),
////            showTime: "14:30",
////            numberOfPeople: 2,
////            ticketType: "全票",
////            seatNumbers: "A1, A2",
////            totalAmount: 600
////        ),
////        MovieTicket(
////            bookingDate: Date(),
////            movieName: "蜘蛛人3",
////            showDate: Date().addingTimeInterval(3600*2),
////            showTime: "16:30",
////            numberOfPeople: 1,
////            ticketType: "全票",
////            seatNumbers: "B1",
////            totalAmount: 300
////        ),
////        MovieTicket(
////            bookingDate: Date(),
////            movieName: "玩具總動員4",
////            showDate: Date(),
////            showTime: "13:30",
////            numberOfPeople: 3,
////            ticketType: "全票",
////            seatNumbers: "C1, C2, C3",
////            totalAmount: 900
////        )
////    ]
////}
////
////enum ServiceError: Error {
////    case fetchError
////    case updateError
////    case deleteError
////}
////
////class GoogleSheetsService: MovieTicketServiceProtocol {
////    private let spreadsheetId = "1pTsdAcJLSO4CgNI481cLPJd9WryuClxmVvgUxBOKM8E"
////    
////    func fetchTickets() async throws -> [MovieTicket] {
////        // 模擬網絡請求延遲
////        try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒延遲
////        return MockData.testTickets
////    }
////    
////    func updateTicket(_ ticket: MovieTicket) async throws {
////        // 實際實現會與 Google Sheets API 互動
////        try await Task.sleep(nanoseconds: 1_000_000_000)
////        // 如果更新失敗，拋出錯誤
////        // throw ServiceError.updateError
////    }
////    
////    func deleteTicket(_ ticket: MovieTicket) async throws {
////        try await Task.sleep(nanoseconds: 1_000_000_000)
////        // 如果刪除失敗，拋出錯誤
////        // throw ServiceError.deleteError
////    }
////}
////
