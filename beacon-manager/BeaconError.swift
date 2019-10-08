import Foundation
import CoreLocation

/// ビーコン検知時のエラー
///
/// - LocationPermissionDenied: 位置情報許可されてない時
/// - MonitoringDidFailFor: CLRegion検知エラー
/// - RangingBeaconsDidFailFor: CLBeaconRegion検知エラー
/// - DidFailWithError: 検知エラー
/// - DidFinishDeferredUpdatesWithError: 検知更新エラー
public enum BeaconError {
    case LocationPermissionDenied
    case MonitoringDidFailFor(region: CLRegion?, error: Error)
    case RangingBeaconsDidFailFor(region: CLBeaconRegion, error: Error)
    case DidFailWithError(error: Error)
    case DidFinishDeferredUpdatesWithError(error: Error?)
}
