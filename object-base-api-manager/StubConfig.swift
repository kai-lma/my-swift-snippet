import Foundation

class StubConfig {
    /// Stub設定モード
    ///
    /// - off: OFFスタブモード
    /// - onWithSuccess: ON成功結果
    /// - onWithError: ONエラー結果
    enum StubMode {
        case off
        case onWithSuccess
        case onWithError(statusCode: UInt, fileName: String)
    }
    
    /// Stubモードスイッチ
    static var mode: StubMode = .onWithSuccess
    
    /// スタブHttpResponse作成するメソード
    ///
    /// - Parameters:
    ///   - request: ApiRequest
    ///   - responseType: ApiResponse
    /// - Returns: IDTHttpResponse
    static func makeStubResponse(request: ApiRequest, responseType: ApiResponse.Type) -> IDTHttpResponse? {
        var status: IDTHttpStatusCode = .httpStatusOk
        var fileName = self.stubJsonResource(for: request)
        
        if case .onWithError(let code, let name) = mode {
            status = IDTHttpStatusCode(rawValue: code) ?? .httpStatusNotFound
            fileName = name
        }
        
        guard let data = loadJsonData(fromResource: fileName) else {
            return nil
        }
        
        return IDTHttpResponse(httpStatus: status, headers: nil, body: data)!
    }
    
    /// JSONからスタブデータ取得するメソード
    ///
    /// - Parameter resource: ソースパース
    /// - Returns: スタブData
    static private func loadJsonData(fromResource resource: String) -> Data? {
        guard let fileUrl = Bundle.main.url(forResource: resource, withExtension: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: fileUrl)
    }
    
    /// そのApiRequestはスタブするかどうかの判断するメソード
    ///
    /// - Parameter request: ApiRequest
    /// - Returns: スタブするかどうか
    static func shouldStub(for request: ApiRequest) -> Bool {
        if case .off = StubConfig.mode {
            return false
        }
        
        switch request {
        case is ChecklistGetApiRequest:
            return true
        
        case is ChecklistItemsGetApiRequest:
            return true
        
        case is ChecklistChecklogsPostApiRequest:
            return true
            
        case is UserLoginPostApiRequest:
            return true
            
        case is GuestLoginPostApiRequest:
            return true
            
        default:
            return false
        }
    }
    
    /// スタブJSONファイル名取得するメソード
    ///
    /// - Parameter request: ApiRequest
    /// - Returns: スタブJSONファイル名
    static func stubJsonResource(for request: ApiRequest) -> String {
        switch request {
        case is ChecklistGetApiRequest:
            return "get_checklist"
            
        case is ChecklistItemsGetApiRequest:
            return "get_checklist_items"
            
        case is ChecklistChecklogsPostApiRequest:
            return "common_success"
            
        case is UserLoginPostApiRequest:
            return "post_user_login"
            
        case is GuestLoginPostApiRequest:
            return "post_guest_login"
            
        default:
            return "common_success"
        }
    }
}
