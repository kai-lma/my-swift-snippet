import Foundation

/// Checklist取得のApiResponseモデル
struct ChecklistGetApiResponse: ApiResponse {
    /// 点検表オブジェクトの配列 
    let checklists: [Checklist]?
}
