import XCTest

class ChecklistChecklogsPostApiRequestTest: XCTestCase {
    let mockChecklistId = Int64(123456789)
    
    let mockPostData: ChecklistChecklogsPostApiRequestModel = {
        let mockLog = Checklog(itemId: 1, selectedIndex: 1, value: "1", comment: "OK")
        return ChecklistChecklogsPostApiRequestModel(startAtDate: Date(), checklogs: [mockLog])
    }()
    
    func testCorrectMethod() {
        let request = ChecklistChecklogsPostApiRequest(checklistId: mockChecklistId, data: mockPostData)
        XCTAssertEqual(request.getMethod()!, .httpMethodPost)
    }
    
    func testCorrectEndpoint() {
        let request = ChecklistChecklogsPostApiRequest(checklistId: mockChecklistId, data: mockPostData)
        XCTAssertEqual(request.endpoint!.url, ApiEndpoint.postChecklistChecklogs(checklistId: mockChecklistId).url)
    }
    
    func testCorrectResponseType() {
        let request = ChecklistChecklogsPostApiRequest(checklistId: mockChecklistId, data: mockPostData)
        XCTAssertTrue(request.responseType.self == ChecklistChecklogsPostApiResponse.self)
    }
}
