import Foundation

/// API通信結果のDelegate
protocol ApiManagerDelegate: class {
    /// API通信の正常終了を通知する。
    ///
    /// - Parameters:
    ///   - apiManager: 通信を行ったマネージャ
    ///   - request: リクエスト
    ///   - response: レスポンス
    func apiManager(apiManager: ApiManager, successApiRequest request: ApiRequest, recievedResponse response: ApiResponse)
    
    /// サーバからのエラー返却を通知する。
    ///
    /// - Parameters:
    ///   - apiManager: 通信を行ったマネージャ
    ///   - request: 失敗したリクエスト
    ///   - error: Apiからのエラー情報
    func apiManager(apiManager: ApiManager, failedApiRequest request: ApiRequest, apiError error: ApiError)
    
    /// API通信の失敗を通知する。サーバにリクエストが到達していない（ex. オフライン, タイムアウト etc) 場合は本メソッドで通知される。
    ///
    /// - Parameters:
    ///   - apiManager: 通信を行ったマネージャ
    ///   - request: 失敗したリクエスト
    ///   - errorCode: 内部エラーコード
    func apiManager(apiManager: ApiManager, failedRequest request: ApiRequest, errorCode: ApiManager.ErrorCode)
}

/// API通信完了通知ためのDelegate
protocol ApiRequestFinishNotificationDelegate: class {
    /// API通信まもなく完了する、準備処理を行う
    ///
    /// - Parameters:
    ///   - apiManager: 通信を行ったマネージャ
    ///   - request: リクエスト
    func apiManager(apiManager: ApiManager, willFinish request: ApiRequest)
    
    /// API通信すでに完了した、後処理を行う
    ///
    /// - Parameters:
    ///   - apiManager: 通信を行ったマネージャ
    ///   - request: リクエスト
    func apiManager(apiManager: ApiManager, didFinished request: ApiRequest)
}

extension ApiRequestFinishNotificationDelegate {
    func apiManager(apiManager: ApiManager, willFinish request: ApiRequest) {}
    func apiManager(apiManager: ApiManager, didFinished request: ApiRequest) {}
}
