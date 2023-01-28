//
//  APIError.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright © 2023 Educa Corp. All rights reserved.
//

import Foundation

enum APIError: Error {
    case error(code: Int, message: String)
    case invalidResponseData(data: Any)
    case unknown
    
    public var displayText: String {
        switch self {
        case .invalidResponseData:
            return "Invalid response"
        case .error(_, let message):
            //switch errorResponseCode
            return message
        case .unknown:
            return "Unknown error"
        }
    }
    
    public var code: Int {
        switch self {
        case .error(let code, _):
            return code
        default :
            return 0
        }
    }
}
