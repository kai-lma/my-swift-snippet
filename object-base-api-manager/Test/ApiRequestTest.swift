import XCTest

class ApiRequestTest: XCTestCase {
    /// Login情報がなければHeaderのAuthorizationがない
    func testGetHeaderTokenNil() {
        LoginInfoManager.default.removeCredential()
        let request = ApiRequest()
        
        var expectHeader = [String: String]()
        expectHeader[IDT_HTTP_HEADER_CONTENT_TYPE] = IDT_HTTP_HEADER_CONTENT_TYPE_APPLICATION_JSON
        expectHeader["Accept"] = IDT_HTTP_HEADER_CONTENT_TYPE_APPLICATION_JSON
        expectHeader["Authorization"] = nil
        
        XCTAssertEqual(request.getHeader(), expectHeader)
    }
    
    /// Login情報がなければHeaderのAuthorizationがある
    func testGetHeaderTokenNotNil() {
        let mockToken = "token"
        
        LoginInfoManager.default.setCredential(accountName: "accountName", token: mockToken)
        
        let request = ApiRequest()
        
        var expectHeader = [String: String]()
        expectHeader[IDT_HTTP_HEADER_CONTENT_TYPE] = IDT_HTTP_HEADER_CONTENT_TYPE_APPLICATION_JSON
        expectHeader["Accept"] = IDT_HTTP_HEADER_CONTENT_TYPE_APPLICATION_JSON
        expectHeader["Authorization"] = "Bearer \(mockToken)"
        
        XCTAssertEqual(request.getHeader(), expectHeader)
    }
    
    /// get/postのprotocolに適応しなければgetMethod()がnil
    func testGetMethodNilIfNotConformToAnyProtocol() {
        let request = ApiRequest()
        XCTAssertNil(request.getMethod())
    }
    
    /// get/postのprotocolに適応しなければmakeHttpRequestがnil
    func testMakeHttpRequestNilIfNotConformToAnyProtocol() {
        let request = ApiRequest()
        XCTAssertNil(request.makeHttpRequest())
    }
}
