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
import BaseCore

extension BaseCore.FactoryContainer {
    
    var gitHubRepoRepository: Factory<GithubRepoRepositoryType> {
        self {
            GithubRepoRepository()
        }
    }
    
    var gitHubRepoUseCase: Factory<GithubRepoUseCaseType> {
        self {
            GithubRepoUseCase()
        }
    }
    
    var githubCoordinator: Factory<UnownedRouter<GithubRepoRoute>?> {
        self {
            nil
        }
    }
}

