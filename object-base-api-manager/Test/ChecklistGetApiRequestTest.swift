import XCTest

class ChecklistGetApiRequestTest: XCTestCase {
    let mockOperationId = Int64(123456789)
    
    func testCorrectMethod() {
        let request = ChecklistGetApiRequest(operationId: mockOperationId)
        XCTAssertEqual(request.getMethod()!, .httpMethodGet)
    }
    
    func testCorrectEndpoint() {
        let request = ChecklistGetApiRequest(operationId: mockOperationId)
        XCTAssertEqual(request.endpoint!.url, ApiEndpoint.getChecklists.url)
    }
    
    func testCorrectResponseType() {
        let request = ChecklistGetApiRequest(operationId: mockOperationId)
        XCTAssertTrue(request.responseType.self == ChecklistGetApiResponse.self)
    }
    
    func testCorrectParams() {
        let request = ChecklistGetApiRequest(operationId: mockOperationId)
        XCTAssertEqual(request.getParamDictionay(), ["operation_id": mockOperationId.description])
    }
}
