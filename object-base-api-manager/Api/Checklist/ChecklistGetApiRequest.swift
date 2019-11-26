import Foundation

/// Checklist取得のApiRequestオブジェクト
class ChecklistGetApiRequest: ApiRequest, ApiGetRequestProtocol {
    override var endpoint: ApiEndpoint? {
        return .getChecklists
    }
    
    override var responseType: ApiResponse.Type {
        return ChecklistGetApiResponse.self
    }
    
    let operationId: Int64
    
    /// イニシャライザ
    ///
    /// - Parameter operationId: 直のID
    init(operationId: Int64) {
        self.operationId = operationId
    }
    
    func getParamDictionay() -> [String: String] {
        var params = [String: String]()
        params["operation_id"] = operationId.description
        return params
    }
}
