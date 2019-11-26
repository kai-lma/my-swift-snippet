import Foundation

/// ApiRequest結果enum
enum ApiRequestResult {
    //成功の場合、responseのモデルをつけ
    case success(ApiResponse)
    
    //エラーの場合、statusCodeと解析できたApiErrorをつけ（serverエラーの場合、ApiErrorがnilになる）
    case error(IDTHttpStatusCode, ApiError?)
}

/// ApiResponseオブジェクトプロトコル
protocol ApiResponse: BaseApiResponseModel {
    /// IDTHttpResponseデータからApiResponseもしくはApiErrorに変換する
    ///
    /// - Parameter httpResponse: HttpHelperからの戻り値
    /// - Returns: RequestResult
    static func parseHttpResponse(httpResponse: IDTHttpResponse) -> ApiRequestResult
}

extension ApiResponse {
    static func parseHttpResponse(httpResponse: IDTHttpResponse) -> ApiRequestResult {
        if let jsonString = String(data: httpResponse.body, encoding: .utf8) {
            IDTDebugLog.print("Body: %@", jsonString)
        }
        
        let data: Data = httpResponse.body.isEmpty ? "{}".data(using: .utf8)! : httpResponse.body
        
        if IDTHttpStatus.isSuccess(httpResponse.httpStatus), let dataModel = self.decode(from: data) {
            return .success(dataModel)
        }
        
        return .error(httpResponse.httpStatus, ApiError.decode(from: httpResponse.body))
    }
}
