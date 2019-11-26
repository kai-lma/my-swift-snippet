import XCTest

class ApiManagerTest: XCTestCase {
    var callback: [String: ApiManagerCallback] = [:]
    
    // MARK: - Test GET Checklists
    
    func testGetCheckListsSuccess() {
        StubConfig.mode = .onWithSuccess
        
        let request = ChecklistGetApiRequest(operationId: 1)
        self.request(request: request, successCheck: { (response) in
            let result = response as! ChecklistGetApiResponse
            XCTAssertNotNil(result)
            XCTAssertNotNil(result.checklists)
            XCTAssertNotNil(result.checklists!.first!.id)
            XCTAssertNotNil(result.checklists!.first!.operation)
            XCTAssertNotNil(result.checklists!.first!.operation!.id)
            XCTAssertNotNil(result.checklists!.first!.operation!.opeName)
            XCTAssertNotNil(result.checklists!.first!.operation!.opeStart)
            XCTAssertNotNil(result.checklists!.first!.operation!.opeEnd)
            XCTAssertNotNil(result.checklists!.first!.checklistName)
            XCTAssertNotNil(result.checklists!.first!.lastSubmitAt)
            XCTAssertTrue((result.checklists!.first!.lastSubmitAt as Any) is Date)
            XCTAssertNotNil(result.checklists!.first!.remarks)
            XCTAssertNotNil(result.checklists!.first!.itemCount)
        })
    }
    
    func testGetCheckListsFailInvalidToken401002() {
        StubConfig.mode = .onWithError(statusCode: 401, fileName: "error_401002")
        
        let request = ChecklistGetApiRequest(operationId: 1)
        self.request(request: request) { error in
            XCTAssertNotNil(error.apiError)
            XCTAssert(error.apiError!.code == ApiErrorCode.tokenInvalid.rawValue)
        }
    }
    
    func testGetCheckListsFailTokenExpired401003() {
        StubConfig.mode = .onWithError(statusCode: 401, fileName: "error_401003")
        
        let request = ChecklistGetApiRequest(operationId: 1)
        self.request(request: request) { error in
            XCTAssertNotNil(error.errorCode)
            XCTAssert(error.errorCode == ApiManager.ErrorCode.tokenExpired)
        }
    }
    
    // MARK: - Test GET Checklist Items
    
    func testGetCheckListsItemsSuccess() {
        StubConfig.mode = .onWithSuccess
        
        let request = ChecklistItemsGetApiRequest(checklistId: 1)
        self.request(request: request, successCheck: { (response) in
            let result = response as! ChecklistItemsGetApiResponse
            XCTAssertNotNil(result)
            XCTAssertNotNil(result.checklist)
            XCTAssertNotNil(result.checklist!.id)
            XCTAssertNotNil(result.checklist!.operation!.id)
            XCTAssertNotNil(result.checklist!.operation!.opeName)
            XCTAssertNotNil(result.checklist!.operation!.opeStart)
            XCTAssertNotNil(result.checklist!.operation!.opeEnd)
            XCTAssertNotNil(result.itemsGroupBySpace)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.space)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.space!.id)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.space!.spaceName)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.space!.speechDicWord)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items!.first!.id)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items!.first!.itemFloor)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items!.first!.itemSubplace)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items!.first!.itemCheckpoint)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items!.first!.itemCheckScopeString)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items!.first!.itemInputPattern)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items!.first!.speechDicWord)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items!.first!.remarks)
            XCTAssertNotNil(result.itemsGroupBySpace!.first!.items!.first!.bleMajourId)
        })
    }
    
    func testGetCheckListsItemsFailInvalidToken401002() {
        StubConfig.mode = .onWithError(statusCode: 401, fileName: "error_401002")
        
        let request = ChecklistItemsGetApiRequest(checklistId: 1)
        self.request(request: request) { error in
            XCTAssertNotNil(error.apiError)
            XCTAssert(error.apiError!.code == ApiErrorCode.tokenInvalid.rawValue)
        }
    }
    
    func testGetCheckListsItemsFailTokenExpired401003() {
        StubConfig.mode = .onWithError(statusCode: 401, fileName: "error_401003")
        
        let request = ChecklistItemsGetApiRequest(checklistId: 1)
        self.request(request: request) { error in
            XCTAssertNotNil(error.errorCode)
            XCTAssert(error.errorCode == ApiManager.ErrorCode.tokenExpired)
        }
    }
    
    // MARK: - Test Post Checklogs
    
    func testPostChecklistChecklogsSuccess() {
        StubConfig.mode = .onWithSuccess
        
        let log = Checklog(itemId: 1, selectedIndex: 1, value: "1", comment: "OK")
        let checklogs = [log]
        let data = ChecklistChecklogsPostApiRequestModel(startAtDate: Date(), checklogs: checklogs)
        let request = ChecklistChecklogsPostApiRequest(checklistId: 1, data: data)
        self.request(request: request, successCheck: { (response) in
            let result = response as? ChecklistChecklogsPostApiResponse
            XCTAssertNotNil(result)
        })
    }
    
    func testPostCheckListChecklogsFailAlreadySent400001() {
        StubConfig.mode = .onWithError(statusCode: 400, fileName: "error_400001")
        
        let log = Checklog(itemId: 1, selectedIndex: 1, value: "1", comment: "OK")
        let checklogs = [log]
        let data = ChecklistChecklogsPostApiRequestModel(startAtDate: Date(), checklogs: checklogs)
        let request = ChecklistChecklogsPostApiRequest(checklistId: 1, data: data)
        self.request(request: request) { error in
            XCTAssertNotNil(error.apiError)
            XCTAssert(error.apiError!.code == ApiErrorCode.alreadySent.rawValue)
            XCTAssertNotNil(error.apiError!.message)
        }
    }
    
    func testPostCheckListChecklogsFailDeadlineOverdue400002() {
        StubConfig.mode = .onWithError(statusCode: 400, fileName: "error_400002")
        
        let log = Checklog(itemId: 1, selectedIndex: 1, value: "1", comment: "OK")
        let checklogs = [log]
        let data = ChecklistChecklogsPostApiRequestModel(startAtDate: Date(), checklogs: checklogs)
        let request = ChecklistChecklogsPostApiRequest(checklistId: 1, data: data)
        self.request(request: request) { error in
            XCTAssertNotNil(error.apiError)
            XCTAssert(error.apiError!.code == ApiErrorCode.deadlineOverdue.rawValue)
            XCTAssertNotNil(error.apiError!.message)
        }
    }
    
    func testPostChecklistChecklogsFailInvalidToken401002() {
        StubConfig.mode = .onWithError(statusCode: 401, fileName: "error_401002")
        
        let log = Checklog(itemId: 1, selectedIndex: 1, value: "1", comment: "OK")
        let checklogs = [log]
        let data = ChecklistChecklogsPostApiRequestModel(startAtDate: Date(), checklogs: checklogs)
        let request = ChecklistChecklogsPostApiRequest(checklistId: 1, data: data)
        self.request(request: request) { error in
            XCTAssertNotNil(error.apiError)
            XCTAssert(error.apiError!.code == ApiErrorCode.tokenInvalid.rawValue)
        }
    }
    
    func testPostChecklistChecklogsFailTokenExpired401003() {
        StubConfig.mode = .onWithError(statusCode: 401, fileName: "error_401003")
        
        let log = Checklog(itemId: 1, selectedIndex: 1, value: "1", comment: "OK")
        let checklogs = [log]
        let data = ChecklistChecklogsPostApiRequestModel(startAtDate: Date(), checklogs: checklogs)
        let request = ChecklistChecklogsPostApiRequest(checklistId: 1, data: data)
        self.request(request: request) { error in
            XCTAssertNotNil(error.errorCode)
            XCTAssert(error.errorCode == ApiManager.ErrorCode.tokenExpired)
        }
    }
    
    // MARK: - Test User login
    
    func testUserLoginSuccess() {
        StubConfig.mode = .onWithSuccess
        
        let request = UserLoginPostApiRequest(accountName: "0000000000", password: "1234")
        self.request(request: request, successCheck: { (response) in
            let result = response as! UserLoginPostApiResponse
            XCTAssertNotNil(result)
            XCTAssertNotNil(result.userName)
            XCTAssertNotNil(result.token)
        })
    }
    
    func testUserLoginFail401001() {
        StubConfig.mode = .onWithError(statusCode: 401, fileName: "error_401001")
        
        let request = UserLoginPostApiRequest(accountName: "0000000000", password: "1234")
        self.request(request: request) { error in
            XCTAssertNotNil(error.apiError)
            XCTAssert(error.apiError!.code == ApiErrorCode.authorizationFailed.rawValue)
        }
    }
    
    // MARK: - Test Guest Login
    
    func testGuestLoginSuccess() {
        StubConfig.mode = .onWithSuccess
        
        let request = GuestLoginPostApiRequest()
        self.request(request: request, successCheck: { (response) in
            let result = response as! GuestLoginPostApiResponse
            XCTAssertNotNil(result)
            XCTAssertNotNil(result.userName)
            XCTAssertNotNil(result.token)
        })
    }
}

extension ApiManagerTest {
    func request(request: ApiRequest, successCheck: ((ApiResponse) -> Void)? = nil, errorCheck: ((ApiManagerCallback.Error) -> Void)? = nil) {
        let key = type(of: request).description()
        let expectation = self.expectation(description: key)
        
        defer {
            self.wait(for: [expectation], timeout: 5)
        }
        
        let manager = ApiManager()
        let onFinish = { (manager: ApiManager) in
            self.callback[key] = nil
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: {
                XCTAssertEqual(manager.runningRequestCount, 0)
                expectation.fulfill()
            })
        }
        
        let callback = ApiManagerCallback(
            onCompleted: { (manager, request, response) in
                XCTAssertNotNil(response)
                successCheck?(response)
                onFinish(manager)
            },
            onFailed: { (manager, request, error) in
                XCTAssertNotNil(error)
                
                if let apiError = error.apiError {
                    XCTAssertNotNil(apiError.code)
                    XCTAssertNotNil(apiError.message)
                }
                
                errorCheck?(error)
                onFinish(manager)
            }
        )
        
        self.callback[key] = callback
        manager.delegate = callback
        _ = manager.request(request: request)
        XCTAssertEqual(manager.runningRequestCount, 1)
    }
}


// ApiManagerコールバックテスト用クラス
class ApiManagerCallback: ApiManagerDelegate {
    typealias CompletionBlock = (ApiManager, ApiRequest, ApiResponse) -> ()
    typealias FailureBlock = (ApiManager, ApiRequest, Error) -> ()
    
    private var onCompleted: CompletionBlock?
    private var onFailed: FailureBlock?
    
    init(onCompleted: @escaping CompletionBlock, onFailed: @escaping FailureBlock) {
        self.onCompleted = onCompleted
        self.onFailed = onFailed
    }
    
    func apiManager(apiManager: ApiManager, successApiRequest request: ApiRequest, recievedResponse response: ApiResponse) {
        self.onCompleted?(apiManager, request, response)
    }
    
    func apiManager(apiManager: ApiManager, failedApiRequest request: ApiRequest, apiError error: ApiError) {
        self.onFailed?(apiManager, request, Error(apiError: error))
    }
    
    func apiManager(apiManager: ApiManager, failedRequest request: ApiRequest, errorCode: ApiManager.ErrorCode) {
        self.onFailed?(apiManager, request, Error(errorCode: errorCode))
    }
    
    struct Error {
        var errorCode: ApiManager.ErrorCode?
        var apiError: ApiError?
        
        init(errorCode: ApiManager.ErrorCode) {
            self.errorCode = errorCode
        }
        
        init(apiError: ApiError) {
            self.apiError = apiError
        }
    }
}

fileprivate extension ApiManager {
    var runningRequestCount: Int? {
        let runningRequest = Mirror(reflecting: self).children.first(where: { $0.label == "runningRequest" })?.value as? [Any]
        return runningRequest?.count
    }
}
