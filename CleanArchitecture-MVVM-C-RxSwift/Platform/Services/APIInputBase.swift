//
//  APIInputBase.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright © 2023 Educa Corp. All rights reserved.
//

import Foundation
import Alamofire

protocol APIInputBase {
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: [String: Any]? { get }
    var requireToken: Bool { get }
}
