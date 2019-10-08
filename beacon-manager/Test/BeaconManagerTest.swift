import XCTest
import CoreLocation
import OCMockitoSwift

class BeaconManagerTest: XCTestCase {
    
    class BeaconManagerDelegateImplementedClass: BeaconManagerDelegate {
        var bm: BeaconManager
        var inBeacons = [Beacon]()
        var newInBeacons = [Beacon]()
        var newOutBeacons = [Beacon]()
        var beaconError: BeaconError?
        var receiveEventCount = 0
        
        init() {
            bm = BeaconManager()
            bm.delegate = self
        }
        
        func beaconManager(manager: BeaconManager, didReceiveNewInBeacons newInBeacons: [Beacon], newOutBeacons: [Beacon]) {
            self.inBeacons = manager.inBeacons
            self.newInBeacons = newInBeacons
            self.newOutBeacons = newOutBeacons
            receiveEventCount = receiveEventCount + 1
        }
        
        func beaconManager(manager: BeaconManager, didEncounterError error: BeaconError) {
            beaconError = error
        }
    }
    
    class MockError: Error { init() {} }
    
    var testImplement: BeaconManagerDelegateImplementedClass!
    let mockLocationManager = mock(CLLocationManager.self) as! CLLocationManager
    let mockBeaconRegion = mock(CLBeaconRegion.self) as! CLBeaconRegion
    
    let mockCLBeaconOne: CLBeacon = {
        let mockBeacon = mock(CLBeacon.self);
        given(mockBeacon) { (#selector(getter: CLBeacon.proximityUUID), willReturn: UUID(uuidString: BeaconSetting.UUID)!) }
        given(mockBeacon) { (#selector(getter: CLBeacon.major), willReturn: 1) }
        given(mockBeacon) { (#selector(getter: CLBeacon.minor), willReturn: 0) }
        return mockBeacon as! CLBeacon
    }()
    
    let mockCLBeaconTwo: CLBeacon = {
        let mockBeacon = mock(CLBeacon.self);
        given(mockBeacon) { (#selector(getter: CLBeacon.proximityUUID), willReturn: UUID(uuidString: BeaconSetting.UUID)!) }
        given(mockBeacon) { (#selector(getter: CLBeacon.major), willReturn: 2) }
        given(mockBeacon) { (#selector(getter: CLBeacon.minor), willReturn: 0) }
        return mockBeacon as! CLBeacon
    }()
    
    override func setUp() {
        testImplement = BeaconManagerDelegateImplementedClass()
    }
    
    override func tearDown() {
        testImplement = nil
    }
    
    /// 検知できたビーコンはinBeaconsに入ります。
    /// 現時点検知できたばかりのビーコンだけnewInBeaconsに返します。
    func testDidRangeBeacons() {
        // １回目の検知。
        let rangingBeacons1 = [mockCLBeaconOne]
        testImplement.bm.locationManager(mockLocationManager, didRangeBeacons: rangingBeacons1, in: mockBeaconRegion)
        
        // 現時点検知できたビーコンはinBeaconsに入ります。
        XCTAssertEqual(testImplement.inBeacons.count, 1)
        XCTAssertNotNil(testImplement.inBeacons.first(where: { $0 == Beacon(fromCLBeacon: mockCLBeaconOne) }))
        
        // 新たに検知できたBeaconOneを返します。
        XCTAssertEqual(testImplement.newInBeacons.count, 1)
        XCTAssertNotNil(testImplement.newInBeacons.first(where: { $0 == Beacon(fromCLBeacon: mockCLBeaconOne) }))
        
        // ２回目の検知。
        let rangingBeacons2 = [mockCLBeaconOne, mockCLBeaconTwo]
        testImplement.bm.locationManager(mockLocationManager, didRangeBeacons: rangingBeacons2, in: mockBeaconRegion)
        
        // 現時点検知できたビーコンはinBeaconsに入ります。
        XCTAssertEqual(testImplement.inBeacons.count, 2)
        XCTAssertNotNil(testImplement.inBeacons.first(where: { $0 == Beacon(fromCLBeacon: mockCLBeaconOne) }))
        XCTAssertNotNil(testImplement.inBeacons.first(where: { $0 == Beacon(fromCLBeacon: mockCLBeaconTwo) }))
        
        // 新たに検知できたBeaconTwoを返します。
        XCTAssertEqual(testImplement.newInBeacons.count, 1)
        XCTAssertNotNil(testImplement.newInBeacons.first(where: { $0 == Beacon(fromCLBeacon: mockCLBeaconTwo) }))
    }
    
    /// ｎ回連続検知できなかったビーコンはinBeaconsに入ってないで、newOutBeaconsで返します。
    func testOutBeaconAfterNTimesDisconnected() {
        // １回目の検知。
        let rangingBeacons1 = [mockCLBeaconOne, mockCLBeaconTwo]
        testImplement.bm.locationManager(mockLocationManager, didRangeBeacons: rangingBeacons1, in: mockBeaconRegion)
        
        // ｎ回連続でBeaconTwoがない時。
        let rangingBeacons2 = [mockCLBeaconOne]
        for _ in 1 ... BeaconSetting.DisconnectThreshold {
            testImplement.bm.locationManager(mockLocationManager, didRangeBeacons: rangingBeacons2, in: mockBeaconRegion)
        }
        
        // Outになったビーコンを除いて、現時点検知できたビーコンはinBeaconsに入ります。
        XCTAssertEqual(testImplement.inBeacons.count, 1)
        XCTAssertNotNil(testImplement.inBeacons.first(where: { $0 == Beacon(fromCLBeacon: mockCLBeaconOne) }))
        
        // BeaconTwoはOutと判定され、newOutBeaconsに返します。
        XCTAssertEqual(testImplement.newOutBeacons.count, 1)
        XCTAssertNotNil(testImplement.newOutBeacons.first(where: { $0 == Beacon(fromCLBeacon: mockCLBeaconTwo) }))
    }
    
    /// ｎ回未満連続検知できなかったビーコンはinBeaconsにまだ残します。
    func testNotOutBeaconIfLessThanNTimes() {
        // １回目の検知。
        let rangingBeacons1 = [mockCLBeaconOne, mockCLBeaconTwo]
        testImplement.bm.locationManager(mockLocationManager, didRangeBeacons: rangingBeacons1, in: mockBeaconRegion)
        
        // ｎ回未満でBeaconTwoがない時。
        let rangingBeacons2 = [mockCLBeaconOne]
        for _ in 1 ..< BeaconSetting.DisconnectThreshold {
            testImplement.bm.locationManager(mockLocationManager, didRangeBeacons: rangingBeacons2, in: mockBeaconRegion)
        }
        
        // ｎ回未満なのでBeaconTwoはまだinBeaconsにあります。
        XCTAssertEqual(testImplement.inBeacons.count, 2)
        XCTAssertEqual(testImplement.inBeacons.first(where: { $0 == Beacon(fromCLBeacon: mockCLBeaconOne) })!.disconnectCount, 0)
        XCTAssertEqual(testImplement.inBeacons.first(where: { $0 == Beacon(fromCLBeacon: mockCLBeaconTwo) })!.disconnectCount, BeaconSetting.DisconnectThreshold - 1)
    }
    
    // 同じ検知結果の場合、新しいエベントを送らない。
    func testRangingBeaconsNotChange() {
        // １回目の検知。
        let rangingBeacons1 = [mockCLBeaconOne]
        
        testImplement.bm.locationManager(mockLocationManager, didRangeBeacons: rangingBeacons1, in: mockBeaconRegion)
        let receiveEventCount = testImplement.receiveEventCount
        
        XCTAssertEqual(receiveEventCount, 1)
        
        // ２回目に同じ検知できたrangingBeacons1の場合、新しいエベントを送らない。
        testImplement.bm.locationManager(mockLocationManager, didRangeBeacons: rangingBeacons1, in: mockBeaconRegion)
        let currentReceiveEventCount = testImplement.receiveEventCount
        
        XCTAssertEqual(receiveEventCount, currentReceiveEventCount)
    }
    
    // エラーのdelegateのメソッドのテストケース
    func testEncounterErrorMethod() {
        let mockError = MockError() as Error
        
        testImplement.bm.locationManager(mockLocationManager, didChangeAuthorization: .denied)
        XCTAssertEqual(testImplement.beaconError!, BeaconError.LocationPermissionDenied)
        
        testImplement.bm.locationManager(mockLocationManager, monitoringDidFailFor: mockBeaconRegion, withError: mockError)
        XCTAssertEqual(testImplement.beaconError!, BeaconError.MonitoringDidFailFor(region: mockBeaconRegion, error: mockError))
        
        testImplement.bm.locationManager(mockLocationManager, rangingBeaconsDidFailFor: mockBeaconRegion, withError: mockError)
        XCTAssertEqual(testImplement.beaconError!, BeaconError.RangingBeaconsDidFailFor(region: mockBeaconRegion, error: mockError))
        
        testImplement.bm.locationManager(mockLocationManager, didFinishDeferredUpdatesWithError: mockError)
        XCTAssertEqual(testImplement.beaconError!, BeaconError.DidFinishDeferredUpdatesWithError(error: mockError))
        
        testImplement.bm.locationManager(mockLocationManager, didFailWithError: mockError)
        XCTAssertEqual(testImplement.beaconError!, BeaconError.DidFailWithError(error: mockError))
    }
}

// テスト用のextension（XCTAssertEqualで判定できるように）
extension BeaconError: Equatable {
    public static func == (lhs: BeaconError, rhs: BeaconError) -> Bool {
        switch (lhs, rhs) {
        case (.LocationPermissionDenied, .LocationPermissionDenied):
            return true
        case (.MonitoringDidFailFor(_, _), .MonitoringDidFailFor(_, _)):
            return true
        case (.RangingBeaconsDidFailFor(_, _), .RangingBeaconsDidFailFor(_, _)):
            return true
        case (.DidFinishDeferredUpdatesWithError(_), .DidFinishDeferredUpdatesWithError(_)):
            return true
        case (.DidFailWithError(_), .DidFailWithError(_)):
            return true
        default:
            return false
        }
    }
}
