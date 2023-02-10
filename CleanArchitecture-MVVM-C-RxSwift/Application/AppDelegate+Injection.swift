//
//  AppDelegate+Injection.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright © 2023 Educa Corp. All rights reserved.
//

import Foundation
import Factory
import XCoordinator

extension SharedContainer {
    var gitHubRepoRepository: Factory<GithubRepoRepository> {
        makes {
            GithubRepoRepository()
        }
    }
    
    var gitHubRepoUseCase: Factory<GithubRepoUseCase> {
        makes {
            GithubRepoUseCase()
        }
    }
    
    var githubCoordinator: Factory<UnownedRouter<GithubRepoRoute>?> {
        makes {
            nil
        }
    }
}

