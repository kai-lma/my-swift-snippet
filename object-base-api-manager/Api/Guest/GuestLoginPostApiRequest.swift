//
//  GuestLoginPostApiRequest.swift
//  TenkenApp
//
//  Created by KAI on 2019/03/13.
//  Copyright © 2019 bravesoft inc. All rights reserved.
//

import Foundation

/// ゲストログイン送信のApiRequestオブジェクト
class GuestLoginPostApiRequest: ApiRequest, ApiPostRequestProtocol {
    override var endpoint: ApiEndpoint? {
        return .guestLogin
    }
    
    override var responseType: ApiResponse.Type {
        return GuestLoginPostApiResponse.self
    }
    
    var postRequestData: BaseApiRequestModel?
    
    /// イニシャライザ
    override init() {
        postRequestData = GuestLoginPostApiRequestModel()
    }
}

/// ゲストログイン送信データのモデル
struct GuestLoginPostApiRequestModel: BaseApiRequestModel {
    
}
