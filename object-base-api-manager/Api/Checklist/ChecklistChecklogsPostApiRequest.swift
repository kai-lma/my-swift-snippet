import Foundation

/// Cheklistのcheklogsを送信するのApiRequestオブジェクト
class ChecklistChecklogsPostApiRequest: ApiRequest, ApiPostRequestProtocol {
    override var endpoint: ApiEndpoint? {
        return .postChecklistChecklogs(checklistId: checklistId)
    }
    
    override var responseType: ApiResponse.Type {
        return ChecklistChecklogsPostApiResponse.self
    }
    
    var postRequestData: BaseApiRequestModel?
    
    let checklistId: Int64
    
    /// イニシャライザ
    ///
    /// - Parameters:
    ///   - checklistId: 点検表のID
    ///   - data: チェックログ送信データ
    init(checklistId: Int64, data: ChecklistChecklogsPostApiRequestModel) {
        self.checklistId = checklistId
        self.postRequestData = data
    }
}

/// Cheklistのcheklogs送信データのモデル
struct ChecklistChecklogsPostApiRequestModel: BaseApiRequestModel {
    /// 点検開始日時を表す文字列
    let startAt: String
    
    /// 点検結果オブジェクトの配列
    let checklogs: [Checklog]
    
    /// イニシャライザ
    ///
    /// - Parameters:
    ///   - startAtDate: start日付
    ///   - checklogs: チェックログ配列データ
    init(startAtDate: Date, checklogs: [Checklog]) {
        self.startAt = startAtDate.toString(format: .iso8601Extended)
        self.checklogs = checklogs
    }
}
