//
//  UserLoginPostApiResponse.swift
//  TenkenApp
//
//  Created by KAI on 2019/03/13.
//  Copyright © 2019 bravesoft inc. All rights reserved.
//

import Foundation

/// ユーザログイン送信のApiResponseモデル
struct UserLoginPostApiResponse: ApiResponse {
    /// アクセストークンを表す文字列
    let token: String?
    
    /// ユーザ名を表す文字列
    let userName: String?
}
