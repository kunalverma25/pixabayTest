//
//  ResultsListPresenter.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol ResultsListPresentationLogic: AnyObject {
    func presentSomething()
}

class ResultsListPresenter: ResultsListPresentationLogic {
    weak var viewController: ResultsListDisplayLogic?
    
    // MARK: Presentation Logic
    
    func presentSomething() {
        viewController?.displaySomething()
    }
}
