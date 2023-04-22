//
//  OverviewInteractorPaginationConfig.swift
//  Art
//
//  Created by Sander de Koning on 22/04/2023.
//

import Foundation

protocol OverviewInteractorPaginationConfigProtocol {
    var firstPageIndex: Int { get }
    var resultsPerPage: Int { get }
    
    func pageToFetchAfter(index: Int, numberOfPages: Int) -> Int?
    func shouldFetch(page: Int, afterIndex index: Int) async -> Bool
}

struct OverviewInteractorPaginationConfig: OverviewInteractorPaginationConfigProtocol {
    // The API page index starts at 1 rather than 0
    let firstPageIndex = 1
    let resultsPerPage = 4

    let prefetchNextPageProgressFractionThreshold = 0.4
    let prefetchNextPageItemThreshold: Int
    
    init() {
        let threshold = Double(resultsPerPage) * prefetchNextPageProgressFractionThreshold
        let thresholdRounded = Int(floor(threshold))
        prefetchNextPageItemThreshold =  thresholdRounded
    }
}

extension OverviewInteractorPaginationConfig {
    func pageToFetchAfter(index: Int, numberOfPages: Int) -> Int? {
        let pageFraction = Double(index + firstPageIndex) / Double(resultsPerPage)
        let page = Int(floor(pageFraction))
        
        let nextPage = page + 1
        guard nextPage <= numberOfPages else {
            return nil
        }
        return nextPage
    }
    
    func shouldFetch(page: Int, afterIndex index: Int) async -> Bool {
        let remainder = (index + 1) % resultsPerPage
        let indexIsPageEnd = remainder == 0
        let indexCrossedThreshold = remainder > prefetchNextPageItemThreshold
        
        let shouldFetch = indexIsPageEnd || indexCrossedThreshold
        return shouldFetch
    }
}
