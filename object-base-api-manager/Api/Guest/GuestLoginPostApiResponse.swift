//
//  GuestLoginPostApiResponse.swift
//  TenkenApp
//
//  Created by KAI on 2019/03/13.
//  Copyright © 2019 bravesoft inc. All rights reserved.
//

import Foundation

/// ゲストログイン送信のApiResponseモデル
struct GuestLoginPostApiResponse: ApiResponse {
    /// アクセストークンを表す文字列
    let token: String?
    
    /// ユーザ名を表す文字列(「ゲスト」で固定)
    let userName: String?
}
