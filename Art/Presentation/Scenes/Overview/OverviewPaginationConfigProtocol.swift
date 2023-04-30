//
//  OverviewPaginationConfigProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import Foundation

protocol OverviewPaginationConfigProtocol {
    var firstPageIndex: Int { get }
    var resultsPerPage: Int { get }

    func pageToFetchAfter(page: Int, numberOfPages: Int) -> Int?
}
