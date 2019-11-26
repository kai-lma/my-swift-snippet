import Foundation

/// Itemモデル
struct Item: BaseModel {
    /// 点検項目ID
    let id: Int64?
    
    /// 点検項目の階を表す文字列
    let itemFloor: String?
    
    /// 点検箇所名
    let itemSubplace: String?
    
    /// 点検項目
    let itemCheckpoint: String?
    
    /// 点検範囲を表す文字列
    let itemCheckScopeString: String?
    
    /// 入力方式を表す整数
    let itemInputPattern: Int64?
    
    /// 読み上げ文字を表す文字列
    let speechDicWord: String?
    
    /// 備考(個別)を表す文字列
    let remarks: String?
    
    /// ビーコンに設定されているメジャーIDを表す文字列
    let bleMajourId: String?
}

extension Item {
    /// ItemのbleMajourIdがビーコン配列にあるかどうか判断する
    ///
    /// - Parameter beacons: ビーコン配列
    /// - Returns: ItemのbleMajourIdがビーコン配列にあるかどうか
    func hasMajorIdIn(_ beacons: [Beacon]) -> Bool{
        guard let majorId = self.bleMajourId, let _ = beacons.firstIndex(where: { $0.major.description == majorId }) else {
            return false
        }
        
        return true
    }
}

/// 点検場所でグループ化された点検項目群のモデル
struct ItemsGroupBySpace: BaseModel {
    /// 点検場所オブジェクト
    let space: CheckSpace?
    
    /// 点検項目オブジェクトの配列
    var items: [Item]?
}

extension ItemsGroupBySpace {
    /// 新しいItemsを追加する
    ///
    /// - Parameter newItems: 新しいItems
    mutating func addItems(newItems: [Item]) {
        self.items?.append(contentsOf: newItems)
    }
    
    /// Items削除する
    ///
    /// - Parameter predicator: フィルタの条件
    mutating func removeItems(where predicator: (Item) -> Bool) {
        self.items = self.items?.filter { !predicator($0) }
    }
    
    /// Itemsが空のか判断する
    ///
    /// - Returns: Itemsが空のか
    func hasEmptyItems() -> Bool {
        return self.items?.count ?? 0 == 0
    }
}
