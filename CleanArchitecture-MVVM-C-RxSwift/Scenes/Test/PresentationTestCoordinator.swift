//  PresentationTestCoordinator.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright (c) 2023 Educa Corp. All rights reserved.
//
//  This file was generated by the Educa MVVM-C Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  Template created by huyparody - huytd@educa.vn

import Foundation
import XCoordinator
import UIKit
import BaseCore

//enum PresentationTestRoute: Route {
//    case demo
//}

//class PresentationTestCoordinator: NavigationCoordinator<PresentationTestRoute> {
//
//    //Init bình thường
//    init() {
//        super.init(initialRoute: .demo)
//    }
//
//    //MARK: Tách coordinator ra từ thằng cha thì dùng hàm này
////    init(rootViewController: UINavigationController) {
////        super.init(rootViewController: rootViewController, initialRoute: nil)
////        trigger(.demo)
//
////        Note: bên ParentRoute khi switch đến case cần tách ở child thì gọi:
////        addChild(ChildCoordinator.init(rootViewController: rootViewController))
////        return .none()
////    }
//
//    override func prepareTransition(for route: PresentationTestRoute) -> NavigationTransition {
//        switch route {
//        case .demo:
//            return .none()
//        }
//    }
//
//}