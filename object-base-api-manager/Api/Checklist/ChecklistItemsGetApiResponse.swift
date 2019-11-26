import Foundation

/// ChecklistのItems取得のApiResponseモデル
struct ChecklistItemsGetApiResponse: ApiResponse {
    /// 点検表オブジェクト
    let checklist: Checklist?
    
    /// 点検場所でグループ化された点検項目群の配列
    let itemsGroupBySpace: [ItemsGroupBySpace]?
}
