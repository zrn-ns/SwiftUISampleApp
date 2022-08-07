//
//  APIError.swift
//  APIClient
//
//  Created by zrn_ns on 2022/08/07.
//

import Alamofire
import Foundation

public enum APIError: Error {
    /// サーバ不達
    case connectionFailure
    /// クライアント側のロジックエラー
    case logicError(systemErrorInfo: String)
    /// キャンセルされた
    case cancelled
    /// その他
    case other

    init(afError: AFError) {
        #warning("あとでちゃんと実装")
        print(afError)
        self = .other
    }
}
