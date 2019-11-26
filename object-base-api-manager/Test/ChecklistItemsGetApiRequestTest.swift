import XCTest

class ChecklistItemsGetApiRequestTest: XCTestCase {
    let mockChecklistId = Int64(123456789)
    
    func testCorrectMethod() {
        let request = ChecklistItemsGetApiRequest(checklistId: mockChecklistId)
        XCTAssertEqual(request.getMethod()!, .httpMethodGet)
    }
    
    func testCorrectEndpoint() {
        let request = ChecklistItemsGetApiRequest(checklistId: mockChecklistId)
        XCTAssertEqual(request.endpoint!.url, ApiEndpoint.getChecklistItems(checklistId: mockChecklistId).url)
    }
    
    func testCorrectResponseType() {
        let request = ChecklistItemsGetApiRequest(checklistId: mockChecklistId)
        XCTAssertTrue(request.responseType.self == ChecklistItemsGetApiResponse.self)
    }
    
    func testCorrectParams() {
        let request = ChecklistItemsGetApiRequest(checklistId: mockChecklistId)
        XCTAssertEqual(request.getParamDictionay(), [:])
    }
}
