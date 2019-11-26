import Foundation

/// Api管理するオブジェクト
class ApiManager: NSObject {
    /// API通信内部エラー（APIエラー以外のエラーコード）
    ///
    /// - tokenExpired: アクセストークンの有効期限切れ
    /// - requestError: リクエストエラー
    /// - otherError: 他の内部エラー
    enum ErrorCode {
        case tokenExpired
        case requestError
        case otherError
    }
    
    typealias RequestSet = (request: ApiRequest, httpRequest: IDTHttpRequest, executor: IDTHttpRequestExecutor, manager: ApiManager)
    
    private var runningRequest: [RequestSet] = []
    
    weak var delegate: ApiManagerDelegate?
    
    weak var notificationDelegate: ApiRequestFinishNotificationDelegate?
    
    /// APIリクエストを送信する
    ///
    /// - Parameter request: リクエスト
    /// - Returns: 送信結果
    func request(request: ApiRequest) -> Bool {
        guard let httpRequest = request.makeHttpRequest() else {
            return false
        }

        let executor = IDTHttpRequestExecutor()
        executor.delegate = self
        
        IDTDebugLog.print("Url: \(httpRequest.url.description)")

        if StubConfig.shouldStub(for: request) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                let httpResponse = StubConfig.makeStubResponse(request: request, responseType: request.responseType)
                self.finishedHttpRequest(httpRequest, httpResponse: httpResponse)
            })
        } else {
            executor.executeHttpRequest(httpRequest)
        }
        
        runningRequest.append((request: request, httpRequest: httpRequest, executor: executor, manager: self))
        
        return true
    }
    
    /// 通信キャンセル
    ///
    /// - Parameter request: キャンセルしたいリクエスト。request(request: ApiRequest)で受け渡したリクエストを指定する
    func cancel(request: ApiRequest) {
        guard let (index, set) = runningRequest.enumerated().first(where: { $1.request == request }) else { return }
        set.executor.cancel()
        runningRequest.remove(at: index)
    }

    private func successRequest(request: ApiRequest, response: ApiResponse) {
        notificationDelegate?.apiManager(apiManager: self, willFinish: request)
        delegate?.apiManager(apiManager: self, successApiRequest: request, recievedResponse: response)
        notificationDelegate?.apiManager(apiManager: self, didFinished: request)
    }
    
    private func failedApiRequest(request: ApiRequest, apiError error: ApiError) {
        notificationDelegate?.apiManager(apiManager: self, willFinish: request)
        delegate?.apiManager(apiManager: self, failedApiRequest: request, apiError: error)
        notificationDelegate?.apiManager(apiManager: self, didFinished: request)
    }
    
    private func failedRequest(request: ApiRequest, errorCode: ApiManager.ErrorCode) {
        notificationDelegate?.apiManager(apiManager: self, willFinish: request)
        delegate?.apiManager(apiManager: self, failedRequest: request, errorCode: errorCode)
        notificationDelegate?.apiManager(apiManager: self, didFinished: request)
    }
}

extension ApiManager: IDTHttpRequestExecutorDelegate {
    func finishedHttpRequest(_ httpRequest: IDTHttpRequest!, httpResponse: IDTHttpResponse!) {
        guard let (index, set) = runningRequest.enumerated().first(where: { $1.httpRequest == httpRequest }) else { return }
        
        defer {
            IDTDebugLog.print("Request finished")
            runningRequest.remove(at: index)
        }
        
        let result = set.request.responseType.parseHttpResponse(httpResponse: httpResponse)
        
        if case .success(let response) = result {
            IDTDebugLog.print("Request succeed")
            successRequest(request: set.request, response: response)
            return
        }
        
        guard case .error(_, let error) = result, let apiError = error else {
            IDTDebugLog.print("ApiError parse error")
            failedRequest(request: set.request, errorCode: .otherError)
            return
        }
        
        if apiError.isTokenExpired() {
            IDTDebugLog.print("Token expired")
            failedRequest(request: set.request, errorCode: .tokenExpired)
            return
        }

        IDTDebugLog.print("ApiError")
        failedApiRequest(request: set.request, apiError: apiError)
    }

    func errorHappenedHttpRequest(_ httpRequest: IDTHttpRequest!, error: Error!) {
        guard let (index, set) = runningRequest.enumerated().first(where: { $1.httpRequest == httpRequest }) else { return }
        
        var code: ErrorCode = .otherError
        
        switch (error as NSError).code {
        case NSURLErrorTimedOut, NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet:
            code = .requestError
        default:
            break
        }
        
        failedRequest(request: set.request, errorCode: code)
        runningRequest.remove(at: index)
    }
    
    func errorHappenedHttpRequest(_ httpRequest: IDTHttpRequest!) {
        guard let (index, set) = runningRequest.enumerated().first(where: { $1.httpRequest == httpRequest }) else { return }
        
        failedRequest(request: set.request, errorCode: .otherError)
        runningRequest.remove(at: index)
    }
}
