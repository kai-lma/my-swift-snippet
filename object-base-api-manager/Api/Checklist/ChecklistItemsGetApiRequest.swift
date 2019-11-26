import Foundation

/// ChecklistのItems取得のApiRequestオブジェクト
class ChecklistItemsGetApiRequest: ApiRequest, ApiGetRequestProtocol {
    override var endpoint: ApiEndpoint? {
        return .getChecklistItems(checklistId: checklistId)
    }
    
    override var responseType: ApiResponse.Type {
        return ChecklistItemsGetApiResponse.self
    }
    
    let checklistId: Int64
    
    /// イニシャライザ
    ///
    /// - Parameter checklistId: 点検表のID
    init(checklistId: Int64) {
        self.checklistId = checklistId
    }
}
