import Foundation

/// Checklistモデル
struct Checklist: BaseModel {
    /// 点検表ID
    let id: Int64?
    
    /// CheckListのOperation
    let operation: Operation?
    
    /// 点検表名
    let checklistName: String?
    
    /// 最終点検記録提出日時
    let lastSubmitAt: Date?
    
    /// 備考(全体)
    let remarks: String?
    
    /// 点検項目に紐づく項目数
    let itemCount: Int64?
}
