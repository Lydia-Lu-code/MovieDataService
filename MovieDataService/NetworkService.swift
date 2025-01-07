//
//  NetworkService.swift
//  CinemaAdmin
//
//  Created by Lydia Lu on 2024/12/25.
//

import Foundation

/// 通用網路服務，負責處理 HTTP 請求
class NetworkService {
    /// 單例模式，確保全域唯一實例
    static let shared = NetworkService()
    
    /// 私有建構子，防止外部直接實例化
    private init() {}
    
    /// 發送 GET 請求的通用方法
    func get(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("❌ 無效的 URL: \(urlString)")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        print("🌐 發送 GET 請求至: \(urlString)")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // 處理錯誤
            if let error = error {
                print("❌ 網路請求錯誤: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            // 檢查 HTTP 回應
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ 無法取得 HTTP 回應")
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            print("✅ 收到回應 狀態碼: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ 非預期的狀態碼: \(httpResponse.statusCode)")
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            // 確保有資料
            guard let data = data else {
                print("❌ 未收到任何資料")
                completion(.failure(NetworkError.noData))
                return
            }
            
            // 額外印出資料內容（用於除錯）
            if let dataString = String(data: data, encoding: .utf8) {
                print("📦 收到的資料: \(dataString)")
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    /// 發送 POST 請求的通用方法
    func post(urlString: String, body: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("❌ 無效的 URL: \(urlString)")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            print("📤 POST 請求內容: \(body)")
        } catch {
            print("❌ 資料序列化失敗: \(error.localizedDescription)")
            completion(.failure(NetworkError.serializationError))
            return
        }
        
        print("🌐 發送 POST 請求至: \(urlString)")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 類似 GET 方法的錯誤處理
            if let error = error {
                print("❌ 網路請求錯誤: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ 無法取得 HTTP 回應")
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            print("✅ 收到回應 狀態碼: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ 非預期的狀態碼: \(httpResponse.statusCode)")
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                print("❌ 未收到任何資料")
                completion(.failure(NetworkError.noData))
                return
            }
            
            // 額外印出資料內容（用於除錯）
            if let dataString = String(data: data, encoding: .utf8) {
                print("📦 收到的資料: \(dataString)")
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

//class NetworkService {
//    /// 單例模式，確保全域唯一實例
//    static let shared = NetworkService()
//    
//    /// 私有建構子，防止外部直接實例化
//    private init() {}
//    
//    /// 發送 GET 請求的通用方法
//    func get(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            // 處理錯誤
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            // 檢查 HTTP 回應
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                completion(.failure(NetworkError.invalidResponse))
//                return
//            }
//            
//            // 確保有資料
//            guard let data = data else {
//                completion(.failure(NetworkError.noData))
//                return
//            }
//            
//            completion(.success(data))
//        }
//        
//        task.resume()
//    }
//    
//    /// 發送 POST 請求的通用方法
//    func post(urlString: String, body: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: body)
//        } catch {
//            completion(.failure(NetworkError.serializationError))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            // 類似 GET 方法的錯誤處理
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                completion(.failure(NetworkError.invalidResponse))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NetworkError.noData))
//                return
//            }
//            
//            completion(.success(data))
//        }
//        
//        task.resume()
//    }
//}

/// 自定義網路錯誤類型
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case serializationError
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "無效的網址"
        case .invalidResponse:
            return "無效的伺服器回應"
        case .noData:
            return "未收到任何資料"
        case .serializationError:
            return "資料序列化失敗"
        case .decodingError:
            return "資料解碼失敗"
        }
    }
}

/// JSON 解碼擴展方法
extension JSONDecoder {
    /// 支援日期格式客製化的解碼方法
    func decodeDate(type: Date.Type = Date.self, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> ((Data) throws -> Date) {
        return { data in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            
            guard let dateString = String(data: data, encoding: .utf8),
                  let date = dateFormatter.date(from: dateString) else {
                throw NetworkError.decodingError
            }
            
            return date
        }
    }
}
