//
//  GithubRepoRepository.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright © 2023 Educa Corp. All rights reserved.
//

import Foundation
import RxSwift
import BaseCore

protocol GithubRepoRepositoryType {
    func searchRepo(query: String) -> Observable<[GithubRepo]>
}

struct GithubRepoRepository: GithubRepoRepositoryType {
    
    func searchRepo(query: String) -> Observable<[GithubRepo]> {
        
        let param: [String: Any] = [
            "q": query,
            "per_page": 10,
            "page": 1
        ]
        
        return APIService
            .shared
            .request(nonBaseResponse: GithubRepoAPIRouter.searchRepos(param: param))
            .compactMap({ (response: GithubRepoModel) -> [GithubRepo] in
                return response.githubRepos ?? []
            })
            .asObservable()
            .catchAndReturnElement([], handler: { error in
                
            })
            .share()
        
        
    }
    
}
