import Foundation
import RxSwift
import SwiftyJSON

fileprivate var internalCache = [String: Data]()

public enum RxURLSessionError: Error {
  case unknown
  case invalidResponse(response: URLResponse)
  case requestFailed(response: HTTPURLResponse, data: Data?)
  case deserializationFailed
}

extension ObservableType where E == (HTTPURLResponse, Data) {
  func cache() -> Observable<E> {
    return self.do(onNext: { (response, data) in
      if let url = response.url?.absoluteString, 200 ..< 300 ~= response.statusCode {
        internalCache[url] = data
      }
    })
  }
}

extension Reactive where Base: URLSession {

  func response(request: URLRequest) -> Observable<(HTTPURLResponse, Data)> {
    return Observable.create { observer in

      let task = self.base.dataTask(with: request) { (data, response, error) in
        guard let response = response, let data = data else {
          observer.on(.error(error ?? RxURLSessionError.unknown))
          return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
          observer.on(.error(RxURLSessionError.invalidResponse(response: response)))
          return
        }
        observer.on(.next(httpResponse, data))
        observer.on(.completed)
      }
      task.resume()

      return Disposables.create(with: task.cancel)
    }
  }

  func data(request: URLRequest) -> Observable<Data> {
    if let url = request.url?.absoluteString, let data = internalCache[url] {
      return Observable.just(data)
    }
    
    return response(request: request).cache().map { (response, data) -> Data in
      if 200 ..< 300 ~= response.statusCode {
        return data
      } else {
        throw RxURLSessionError.requestFailed(response: response, data: data)
      }
    }
  }

  public func string(request: URLRequest) -> Observable<String> {
    return data(request: request).map { d in
      return String(data: d, encoding: .utf8) ?? ""
    }
  }

  public func json(request: URLRequest) -> Observable<JSON> {
    return data(request: request).map { d in
      let json = JSON(data: d)
      if json.object is NSNull {
        throw RxURLSessionError.deserializationFailed
      }
      return json
    }
  }

  public func image(request: URLRequest) -> Observable<UIImage> {
    return data(request: request).map { d in
      if let image = UIImage(data: d) {
        return image
      } else {
        throw RxURLSessionError.deserializationFailed
      }
    }
  }

}
