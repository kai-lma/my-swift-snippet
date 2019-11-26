import Foundation

/// ApiRequestプロトコル
protocol ApiRequestProtocol {
    /// リクエストに対してレスポンスのタイプ
    var responseType: ApiResponse.Type { get }
    
    /// リクエストendpoint
    var endpoint: ApiEndpoint? { get }
}

extension ApiRequestProtocol {
    /// ApiRequestからHttpHelper用のIDTHttpRequestモデルへの変換
    ///
    /// - Returns: IDTHttpRequest
    func makeHttpRequest() -> IDTHttpRequest? {
        
        let header = getHeader()
        
        guard let url = endpoint?.url, let method = getMethod() else {
            return nil
        }
        
        if let getRequestProtocolSelf = self as? ApiGetRequestProtocol {
            let params = getRequestProtocolSelf.getParamDictionay()
            return IDTHttpRequest(url: url, httpMethod: method, headers: NSMutableDictionary(dictionary: header), params: NSMutableDictionary(dictionary: params))
        }
        
        if let postRequestProtocolSelf = self as? ApiPostRequestProtocol {
            let data = postRequestProtocolSelf.getData()
            return IDTHttpRequest(url: url, httpMethod: method, headers: NSMutableDictionary(dictionary: header), binaryBody: data)
        }
        
        return nil
    }
    
    /// リクエストの共通ヘッダーの作成
    ///
    /// - Returns: ヘッダーのディクショナリー
    func getHeader() -> [String: String] {
        var header: [String: String] = [:]
        header[IDT_HTTP_HEADER_CONTENT_TYPE] = IDT_HTTP_HEADER_CONTENT_TYPE_APPLICATION_JSON
        header["Accept"] = IDT_HTTP_HEADER_CONTENT_TYPE_APPLICATION_JSON
        
        if let token = LoginInfoManager.default.token {
            header["Authorization"] = "Bearer \(token)"
        } else {
            header["Authorization"] = nil
        }
        
        return header
    }
    
    /// リクエストメソッド取得
    ///
    /// - Returns: IDTHttpMethod
    func getMethod() -> IDTHttpMethod? {
        if let _ = self as? ApiGetRequestProtocol {
            return .httpMethodGet
        }
        
        if let _ = self as? ApiPostRequestProtocol {
            return .httpMethodPost
        }
        
        return nil
    }
}

/// ApiGetRequestプロトコル
protocol ApiGetRequestProtocol {
    /// リクエストメソッドがゲットの場合、クエリパラメータディクショナリーの作成
    ///
    /// - Returns: クエリパラメータディクショナリー
    func getParamDictionay() -> [String : String]
}

extension ApiGetRequestProtocol {
    func getParamDictionay() -> [String : String] {
        return [:]
    }
}

/// ApiPostRequestプロトコル
protocol ApiPostRequestProtocol {
    /// リクエストメソッドがポストの場合に使うデータモデル
    var postRequestData: BaseApiRequestModel? { get }
    
    /// リクエストのポストデータモデルからjsonデータへ変換する
    ///
    /// - Returns: jsonデータ
    func getData() -> Data?
}

extension ApiPostRequestProtocol {
    func getData() -> Data? {
        let result = self.postRequestData?.encode()
        
        if let result = result, let json = String(bytes: result, encoding: .utf8) {
            IDTDebugLog.print("Json : \(json)")
        }
        
        return result
    }
}

/// ApiRequestクラス
class ApiRequest: NSObject, ApiRequestProtocol {
    /// リクエストに対してレスポンスのタイプ
    var responseType: ApiResponse.Type { return EmptyApiResponse.self }
    
    /// リクエストendpoint
    var endpoint: ApiEndpoint? { return nil }
    
    /// 空ApiResponse
    struct EmptyApiResponse: ApiResponse {}
}
