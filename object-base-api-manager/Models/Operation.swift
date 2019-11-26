import Foundation

/// Operationモデル
struct Operation: BaseModel {
    /// 直情報ID
    let id: Int64?
    
    /// 直情報名
    let opeName: String?
    
    /// 直開始時間
    let opeStart: String?
    
    /// 直終了時間
    let opeEnd: String?
}
