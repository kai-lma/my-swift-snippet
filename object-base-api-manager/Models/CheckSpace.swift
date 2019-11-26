import Foundation

/// CheckSpaceモデル
struct CheckSpace: BaseModel {
    /// 点検場所ID
    let id: Int64?
    
    /// 点検場所名
    let spaceName: String?
    
    /// 点検場所言葉
    let speechDicWord: String?
}
