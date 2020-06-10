//
//  ResultsListPresenter.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol ResultsListPresentationLogic: AnyObject {
    func updateFetchedImages(originalCount: Int, newCount: Int)
}

class ResultsListPresenter: ResultsListPresentationLogic {
    weak var viewController: ResultsListDisplayLogic?
    
    // MARK: Presentation Logic
    
    func updateFetchedImages(originalCount: Int, newCount: Int) {
        let indexPathsToReload = calculateIndexPathsToReload(originalCount: originalCount, newCount: newCount)
        viewController?.updateTable(for: indexPathsToReload)
    }
    
    private func calculateIndexPathsToReload(originalCount: Int, newCount: Int) -> [IndexPath] {
        let startIndex = originalCount
        let endIndex = startIndex + (newCount - originalCount)
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
