//
//  GithubRepoUseCase.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright © 2023 Educa Corp. All rights reserved.
//

import Foundation
import RxSwift
import Factory

protocol GithubRepoUseCaseType {
    func searchRepo(query: String) -> Observable<[GithubRepo]>
}

class GithubRepoUseCase: GithubRepoUseCaseType {
    
    @LazyInjected(\.gitHubRepoRepository) private var repository
    
    func searchRepo(query: String) -> Observable<[GithubRepo]> {
        return repository.searchRepo(query: query)
    }
    
}
