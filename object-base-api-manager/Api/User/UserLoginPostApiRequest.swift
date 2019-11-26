//
//  UserLoginPostApiRequest.swift
//  TenkenApp
//
//  Created by KAI on 2019/03/13.
//  Copyright © 2019 bravesoft inc. All rights reserved.
//

import Foundation

/// ユーザログイン送信のApiRequestオブジェクト
class UserLoginPostApiRequest: ApiRequest, ApiPostRequestProtocol {
    override var endpoint: ApiEndpoint? {
        return .userLogin
    }
    
    override var responseType: ApiResponse.Type {
        return UserLoginPostApiResponse.self
    }
    
    var postRequestData: BaseApiRequestModel?
    
    /// イニシャライザ
    ///
    /// - Parameters:
    ///   - accountName: アカウント名
    ///   - password: パスワード
    init(accountName: String, password: String) {
        postRequestData = UserLoginPostApiRequestModel(accountName: accountName, password: password)
    }
}

/// ユーザログイン送信データのモデル
struct UserLoginPostApiRequestModel: BaseApiRequestModel {
    /// プラント共通機能APIのユーザ認証APIに設定するアカウント名
    let accountName: String
    
    /// プラント共通機能APIのユーザ認証APIに設定するパスワード
    let password: String
    
    /// イニシャライザ
    ///
    /// - Parameters:
    ///   - accountName: アカウント名
    ///   - password:パスワード
    init(accountName: String, password: String) {
        self.accountName = accountName
        self.password = password
    }
}
