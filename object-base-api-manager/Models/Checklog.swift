import Foundation

/// Checklogモデル
struct Checklog: BaseModel {
    /// 点検項目ID
    let itemId: Int64?
    
    /// 点検項目の選択したindex
    let selectedIndex: Int64?
    
    /// 点検項目の値
    let value: String?
    
    /// 点検項目のコメント
    let comment: String?
    
    /// カスタムエンコーダ：データがnilの時nullに変換する
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(itemId, forKey: .itemId)
        try container.encode(selectedIndex, forKey: .selectedIndex)
        try container.encode(value, forKey: .value)
        try container.encode(comment, forKey: .comment)
    }
}

/// 点検場所でグループ化された点検結果群のモデル
struct ChecklogsGroupBySpace: BaseModel {
    /// 点検場所オブジェクト
    let space: CheckSpace?
    
    /// 点検結果オブジェクトの配列
    let checklogs: [Checklog]?
}
