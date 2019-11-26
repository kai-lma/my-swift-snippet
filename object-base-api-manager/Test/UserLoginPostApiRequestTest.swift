import XCTest

class UserLoginPostApiRequestTest: XCTestCase {
    func testCorrectMethod() {
        let request = UserLoginPostApiRequest(accountName: "accountName", password: "password")
        XCTAssertEqual(request.getMethod()!, .httpMethodPost)
    }

    func testCorrectEndpoint() {
        let request = UserLoginPostApiRequest(accountName: "accountName", password: "password")
        XCTAssertEqual(request.endpoint!.url, ApiEndpoint.userLogin.url)
    }

    func testCorrectResponseType() {
        let request = UserLoginPostApiRequest(accountName: "accountName", password: "password")
        XCTAssertTrue(request.responseType.self == UserLoginPostApiResponse.self)
    }
}
