import Foundation

/// CheckStartモデル
struct CheckStart: BaseModel {
    /// 点検開始日時ID
    let id: Int64?
    
    /// 点検表ID
    let checklistId: Int64?
    
    /// 点検開始日時
    let startAt: Date?
}

