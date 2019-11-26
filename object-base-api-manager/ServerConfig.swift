
import UIKit

class ServerConfig: NSObject {
    #if STAGING
    /// サービスAPIのサーバードメイン
    static let serverDomain = "staging_server_domain"
    #else
    /// サービスAPIのサーバードメイン
    static let serverDomain = "product_server_domain"
    #endif
}

/// ドメインのタイプ
struct DomainType {
    /// Api
    static let api = "/api"
}

/// ApiVersion定義するenum
enum ApiVersion: String {
    /// v1
    case v1 = "/v1"
    
    /// 現在使っているApiVersion
    static var current: String { return ApiVersion.v1.rawValue }
}

/// 全てApiEndpoint定義するenum
enum ApiEndpoint {
    /// チェックリスト
    case getChecklists // 点検表を取得する
    case getChecklistItems(checklistId: Int64) // 点検表内の全点検項目を点検場所でグルーピングして取得する
    case postChecklistChecklogs(checklistId: Int64) // 点検結果を送信する
    
    /// ユーザ
    case userLogin // ログインを実行する
    
    /// ゲスト
    case guestLogin // ゲストログイン用エンドポイント
    
    /// パース
    var path: String {
        switch self {
        case .getChecklists:
            return "/checklists"
            
        case let .getChecklistItems(checklistId):
            return "/checklists/\(checklistId)/items"
            
        case let .postChecklistChecklogs(checklistId):
            return "/checklists/\(checklistId)/checklogs"
            
        case .userLogin:
            return "/users/login"
            
        case .guestLogin:
            return "/guests/login"
        }
    }
    
    /// フルパースurl
    var url: String {
        return ServerConfig.serverDomain + DomainType.api + ApiVersion.current + path
    }
}
