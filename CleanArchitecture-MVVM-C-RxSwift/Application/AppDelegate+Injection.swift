//
//  AppDelegate+Injection.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright © 2023 Educa Corp. All rights reserved.
//

import Foundation
import Factory

extension Container {
    var gitHubRepoRepository: Factory<GithubRepoRepository> {
        factory {
            GithubRepoRepository()
        }
    }
    
    var gitHubRepoUseCase: Factory<GithubRepoUseCase> {
        factory {
            GithubRepoUseCase()
        }
    }
}

