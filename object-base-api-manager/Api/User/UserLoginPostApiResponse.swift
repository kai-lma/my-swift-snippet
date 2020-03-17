import Foundation

/// ユーザログイン送信のApiResponseモデル
struct UserLoginPostApiResponse: ApiResponse {
    /// アクセストークンを表す文字列
    let token: String?
    
    /// ユーザ名を表す文字列
    let userName: String?
}
