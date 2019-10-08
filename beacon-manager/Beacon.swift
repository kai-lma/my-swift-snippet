import CoreLocation

/// disconnectCountのステートを保存するためのカスタムBeaconクラス
class Beacon {
    private(set) var uuid: UUID
    private(set) var major: NSNumber
    private(set) var minor: NSNumber
    private(set) var proximity: CLProximity = .unknown
    private(set) var rssi: Int = 0
    private(set) var disconnectCount = 0
    
    var isDisconnected: Bool {
        return disconnectCount >= BeaconSetting.DisconnectThreshold
    }
    
    /// CoreLocationのCLBeaconオブジェクトからイニシャライザ
    ///
    /// - Parameter beacon: CoreLocationのCLBeacon
    init(fromCLBeacon beacon: CLBeacon) {
        uuid = beacon.proximityUUID
        minor = beacon.minor
        major = beacon.major
        proximity = beacon.proximity
        rssi = beacon.rssi
    }
    
    /// アップデートビーコン情報
    ///
    /// - Parameter beacon: 検知したBeacon
    public func update(withBeacon beacon: Beacon) {
        disconnectCount = 0
        proximity = beacon.proximity
        rssi = beacon.rssi
    }
    
    /// Outステートをカウントするメソード
    public func countDisconnect() {
        disconnectCount = disconnectCount + 1
    }
}

extension Beacon: Equatable {
    static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.uuid.uuidString == rhs.uuid.uuidString
            && lhs.major == rhs.major
            && lhs.minor == rhs.minor
    }
}

extension Beacon: CustomStringConvertible {
    var description: String {
        return """
        ==Beacon==
        major: \(major)
        minor: \(minor)
        proximity: \(proximity)
        rssi: \(rssi)
        count: \(disconnectCount)
        ====
        """
    }
}

extension CLProximity: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown :
            return "unknown"
        case .far:
            return "far"
        case .near:
            return "near"
        case .immediate:
            return "immediate"
        }
    }
}
