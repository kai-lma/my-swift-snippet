import Foundation

/// BeaconManager結果のDelegate
protocol BeaconManagerDelegate: class {
    
    /// ビーコン検知結果返すメソード、
    ///
    /// - Parameters:
    ///   - manager: BeaconManagerクラス
    ///   - newInBeacons: 新たにin状態になったビーコンの配列
    ///   - newOutBeacons: 新たにout状態になったビーコンの配列
    func beaconManager(manager: BeaconManager, didReceiveNewInBeacons newInBeacons: [Beacon], newOutBeacons: [Beacon])
    
    /// BeaconManagerからエラーを返すメソード
    ///
    /// - Parameters:
    ///   - manager: BeaconManagerクラス
    ///   - error: BeaconError
    func beaconManager(manager: BeaconManager, didEncounterError error: BeaconError)
}

/// BeaconManager通知Delegate
protocol BeaconManagerNotificationDelegate: class {
    /// ビーコン検知開始通知
    func beaconManagerDidStartMonitoring()
    
    /// ビーコン検知停止通知
    func beaconManagerDidStopMonitoring()
    
    /// Location許可しない時の通知
    func beaconManagerLocationPermissionDenied()
}
