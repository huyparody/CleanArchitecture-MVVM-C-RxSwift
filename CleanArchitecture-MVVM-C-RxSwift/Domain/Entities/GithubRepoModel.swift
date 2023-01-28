//  GithubRepoModel.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright (c) 2023 Educa Corp. All rights reserved.
//
//  This file was generated by the Educa MVVM-C Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  Template created by huyparody - huytd@educa.vn

import UIKit
import ObjectMapper


class GithubRepoModel: Mappable {
    
    var githubRepos: [GithubRepo]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        githubRepos <- map["items"]
    }
}

class GithubRepo: Mappable {
    
    var id: Int?
    var name: String?
    var fullname: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        fullname <- map["full_name"]
    }
    
    
}
