import Foundation

/// ベースモデル
protocol BaseModel: Codable, Hashable {}

/// ベースApiRequestモデル
protocol BaseApiRequestModel: Encodable {}

/// ベースApiResponseモデル
protocol BaseApiResponseModel: Decodable {}

// MARK: - Encodable extension
extension Encodable {
    /// model -> json data を行う
    /// - Returns: jsonデータ
    func encode() -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        var result: Data?
        do {
            result = try encoder.encode(self)
        } catch let error {
            IDTDebugLog.print("Json encode error: \(error)")
            return nil
        }
        
        return result
    }
}

// MARK: - Decodable extension
extension Decodable {
    /// json data -> model を行う
    /// - Parameter data: jsonデータ
    /// - Returns: Responseモデル
    static func decode(from data: Data) -> Self? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode(self, from: data)
        } catch let error {
            IDTDebugLog.print("Json decode error: \(error)")
            return nil
        }
    }
}
