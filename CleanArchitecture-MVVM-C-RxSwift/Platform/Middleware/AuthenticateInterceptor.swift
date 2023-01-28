//
//  AuthenticateInterceptor.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright © 2023 Educa Corp. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import BaseCore

struct OAuthCredential: AuthenticationCredential {
    
    let accessToken: String
    let refreshToken: String
    let expiration: Date

    /// Gọi refresh token nếu local date lớn hơn thời gian token (lưu trong userdefaults) sẽ hết hạn
    var requiresRefresh: Bool { Date().localDate() > expiration }
}

class OAuthAuthenticator: Authenticator {
    
    private let bag = DisposeBag()
    
    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(credential.accessToken))
    }

    func refresh(_ credential: OAuthCredential, for session: Session, completion: @escaping (Result<OAuthCredential, Error>) -> Void) {
        if credential.requiresRefresh {
            //call refresh here
        }
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        let token = HTTPHeader.authorization(credential.accessToken).value
        return urlRequest.headers["Authorization"] == token
    }
}
