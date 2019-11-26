import XCTest

class GuestLoginPostApiRequestTest: XCTestCase {
    func testCorrectMethod() {
        let request = GuestLoginPostApiRequest()
        XCTAssertEqual(request.getMethod()!, .httpMethodPost)
    }
    
    func testCorrectEndpoint() {
        let request = GuestLoginPostApiRequest()
        XCTAssertEqual(request.endpoint!.url, ApiEndpoint.guestLogin.url)
    }
    
    func testCorrectResponseType() {
        let request = GuestLoginPostApiRequest()
        XCTAssertTrue(request.responseType.self == GuestLoginPostApiResponse.self)
    }
}
