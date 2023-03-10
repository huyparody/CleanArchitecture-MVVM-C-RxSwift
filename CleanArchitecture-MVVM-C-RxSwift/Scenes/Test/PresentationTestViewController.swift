//  PresentationTestViewController.swift
//  CleanArchitecture-MVVM-C-RxSwift
//
//  Created by Huy Trinh Duc on 28/01/2023.
//  Copyright (c) 2023 Educa Corp. All rights reserved.
//
//  This file was generated by the Educa MVVM-C Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  Template created by huyparody - huytd@educa.vn

import UIKit
import RxSwift
import RxCocoa
import BaseCore

class PresentationTestViewController: EducaViewController<PresentationTestViewModel> {
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        
    }
    
    private func setupUI() {
        
    }
    
    override func bindViewModel() {
        let input = PresentationTestViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.title
            .drive(self.rx.title)
            .disposed(by: bag)
    }
}
