import UIKit
import CoreLocation

/// ビーコン検知管理するクラス
class BeaconManager: NSObject {
    weak var delegate: BeaconManagerDelegate?
    weak var notificationDelegate: BeaconManagerNotificationDelegate?
    
    let uuid = UUID(uuidString: BeaconSetting.UUID)!
    
    private let initialLocationAuthStatus = CLLocationManager.authorizationStatus()
    
    private(set) var locationManager: CLLocationManager!
    private(set) var beaconRegion: CLBeaconRegion!
    private(set) var inBeacons = [Beacon]()
    
    override init() {
        super.init()
        
        // Setup locationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        
        // Setup beaconRegion
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: BeaconSetting.RegionId)
        beaconRegion.notifyEntryStateOnDisplay = false
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
    }
    
    deinit {
        stopMonitoring()
    }
    
    /// ビーコン検知開始メソード
    func startMonitoring() {
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            
        case .denied, .restricted:
            delegate?.beaconManager(manager: self, didEncounterError: .LocationPermissionDenied)
            notificationDelegate?.beaconManagerDidStopMonitoring()
            notificationDelegate?.beaconManagerLocationPermissionDenied()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
            notificationDelegate?.beaconManagerDidStartMonitoring()
        }
    }
    
    /// ビーコン検知終了メソード
    func stopMonitoring() {
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
        notificationDelegate?.beaconManagerDidStopMonitoring()
    }
    
    /// アプデートinBeaconsやoutBeacons
    ///
    /// - Parameter rangingBeacons: 検知したCLBeaconからBeaconに変換した配列
    private func didRangeBeacons(rangingBeacons: [Beacon]) {
        var newInBeacons = [Beacon]()
        var newOutBeacons = [Beacon]()
        
        for beacon in inBeacons {
            if !rangingBeacons.contains(beacon) {
                beacon.countDisconnect()
                if beacon.isDisconnected {
                    newOutBeacons.append(beacon)
                }
            }
        }
        
        for rangingBeacon in rangingBeacons {
            if let beacon = inBeacons.first(where: { $0 == rangingBeacon }) {
                beacon.update(withBeacon: rangingBeacon)
            } else {
                inBeacons.append(rangingBeacon)
                newInBeacons.append(rangingBeacon)
            }
        }
        
        inBeacons = inBeacons.filter({ !$0.isDisconnected })
        
        if newInBeacons.count != 0 || newOutBeacons.count != 0 {
            delegate?.beaconManager(manager: self, didReceiveNewInBeacons: newInBeacons, newOutBeacons: newOutBeacons)
        }
    }
}

extension BeaconManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // この関数は権限変更する時のみ処理する
        guard initialLocationAuthStatus != status else { return }
        
        if status == .restricted || status == .denied {
            delegate?.beaconManager(manager: self, didEncounterError: .LocationPermissionDenied)
            notificationDelegate?.beaconManagerDidStopMonitoring()
            notificationDelegate?.beaconManagerLocationPermissionDenied()
            return
        }
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startMonitoring()
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        didRangeBeacons(rangingBeacons: beacons.map { Beacon(fromCLBeacon: $0) })
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        delegate?.beaconManager(manager: self, didEncounterError: .MonitoringDidFailFor(region: region, error: error))
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        delegate?.beaconManager(manager: self, didEncounterError: .RangingBeaconsDidFailFor(region: region, error: error))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.beaconManager(manager: self, didEncounterError: .DidFailWithError(error: error))
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        delegate?.beaconManager(manager: self, didEncounterError: .DidFinishDeferredUpdatesWithError(error: error))
    }
}
