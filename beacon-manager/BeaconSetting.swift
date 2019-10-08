import Foundation

/// ビーコン検知周りの設定
final class BeaconSetting {
    /// ビーコンのUUID
    #if STAGING
    static let UUID = "00050001-0000-1000-8000-00805F9B0131"
    #else
    static let UUID = "f9e71d24-ad9a-11e8-98d0-529269fb1459"
    #endif
    
    /// CLBeaconRegionのidentifier
    static let RegionId = "BeaconRegionIdentifierString"
    
    /// ビーコンoutと判定とする回数
    static let DisconnectThreshold = 5
}
