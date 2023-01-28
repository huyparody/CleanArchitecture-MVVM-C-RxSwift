//
//  UserUtils.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright © 2023 Educa Corp. All rights reserved.
//

import Foundation
import BaseCore

public struct UserUtils {

    struct UserDefaultKey {
        static let Theme = "theme"
        static let TokenLogin = "accessToken"
        static let RefreshToken = "refreshToken"
        static let TimeTokenExpire = "timeTokenExpire"
    }

    //MARK: User tokens
    
    static func tokenWillExpiredAt() -> Date {
        //Token expire trong 15 phút
        return Date().localDate().plusMinutes(15)
    }

    static func isLoggedIn () -> Bool {
        if let token = UserDefaults.standard.string(forKey: UserUtils.UserDefaultKey.TokenLogin) {
            return !token.isEmpty
        }
        return false
    }

    static func saveTokens(accessToken: String, refreshToken: String) {
        UserDefaults.standard.set(accessToken, forKey: UserUtils.UserDefaultKey.TokenLogin)
        UserDefaults.standard.set(refreshToken, forKey: UserUtils.UserDefaultKey.RefreshToken)
        UserDefaults.standard.set(UserUtils.tokenWillExpiredAt(), forKey: UserUtils.UserDefaultKey.TimeTokenExpire)
    }

    static func getAccessToken() -> String {
        return UserDefaults.standard.string(forKey: UserUtils.UserDefaultKey.TokenLogin) ?? ""
    }

    static func getTimeTokenExpire() -> Date? {
        if let time = UserDefaults.standard.object(forKey: UserUtils.UserDefaultKey.TimeTokenExpire) as? Date {
            return time
        }
        return nil
    }

    static func getRefreshToken() -> String {
        return UserDefaults.standard.string(forKey: UserUtils.UserDefaultKey.RefreshToken) ?? ""
    }

    static func removeTokens() {
        UserDefaults.standard.removeObject(forKey: UserUtils.UserDefaultKey.TokenLogin)
        UserDefaults.standard.removeObject(forKey: UserUtils.UserDefaultKey.RefreshToken)
        UserDefaults.standard.removeObject(forKey: UserUtils.UserDefaultKey.TimeTokenExpire)
    }

}
