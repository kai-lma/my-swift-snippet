import Foundation

/// APIから戻るエラーのモデル
struct ApiError: Decodable, Hashable {
    /// json -> modelにデコードする時に使うjson keyの設定
    enum CodingKeys: String, CodingKey {
        case error
    }

    /// json -> modelにデコードする時に使うjson keyの設定
    enum ErrorKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
    
    /// エラーコードを表す数値
    let code: Int?
    
    /// エラーメッセージを表す文字列(
    let message: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: ErrorKeys.self, forKey: .error)
        code = try nestedContainer.decode(Int?.self, forKey: .code)
        message = try nestedContainer.decode(String?.self, forKey: .message)
    }
}

/// エラーコードをチェックし、エラータイプを判定するためのメソッド
extension ApiError {
    /// トークンの期限が切れてるかどうか
    ///
    /// - Returns: true: トークンの期限切れ、false: 特になし
    func isTokenExpired() -> Bool {
        let errorCode = code.flatMap({ ApiErrorCode(rawValue: $0) })
        return errorCode == .tokenExpired
    }
}


/// ApiエラーResponseコード
enum ApiErrorCode: Int, Decodable {
    // 400001 - すでに点検結果を送信している
    case alreadySent = 400001
    
    // 400002 - 点検表の提出期限が過ぎた
    case deadlineOverdue = 400002
    
    // 401001 - 認証エラー(センサーNW・データレイクAPIv1のユーザ認証APIのステータスコードが0以外)
    case authorizationFailed = 401001
    
    // 401002 - アクセストークンの指定方法間違い(Authorizationヘッダが存在しない。トークンが空文字など)
    case tokenInvalid = 401002
    
    // 401003 - アクセストークンの有効期限切れ
    case tokenExpired = 401003
}
