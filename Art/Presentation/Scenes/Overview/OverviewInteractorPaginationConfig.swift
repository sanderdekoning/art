//
//  OverviewInteractorPaginationConfig.swift
//  Art
//
//  Created by Sander de Koning on 22/04/2023.
//

import Foundation

struct OverviewInteractorPaginationConfig: OverviewInteractorPaginationConfigProtocol {
    // The API page index starts at 1 rather than 0
    let firstPageIndex = 1
    let resultsPerPage = 4
}

extension OverviewInteractorPaginationConfig {
    func pageToFetchAfter(page: Int, numberOfPages: Int) -> Int? {
        let nextPage = page + 1

        guard nextPage <= numberOfPages else {
            return nil
        }
        return nextPage
    }
}
