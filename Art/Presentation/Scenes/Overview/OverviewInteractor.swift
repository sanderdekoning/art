//
//  OverviewInteractor.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import Foundation

protocol OverviewInteractorProtocol: AnyObject {
    func refresh(with involvedMaker: String) async throws
    func willDisplayArt(at indexPath: IndexPath, for involvedMaker: String) async throws
}

class OverviewInteractor {
    let presenter: OverviewPresenterProtocol
    
    private let collectionWorker = CollectionWorker()
    private var collectionPageResponse = CollectionPageResponse()
    
    // The API page index starts at 1 rather than 0
    private let firstPageIndex = 1
    private let resultsPerPage = 4
    
    init(presenter: any OverviewPresenterProtocol) {
        self.presenter = presenter
    }
}

extension OverviewInteractor: OverviewInteractorProtocol {
    func refresh(with involvedMaker: String) async throws {
        await collectionPageResponse.removeAll()
        
        let request = CollectionRequest(
            involvedMaker: involvedMaker,
            resultsPerPage: resultsPerPage,
            page: firstPageIndex
        )
        try await fetchCollection(for: request)
    }
    
    func willDisplayArt(at indexPath: IndexPath, for involvedMaker: String) async throws {
        guard let nextPath = await pageToFetchAfter(index: indexPath.item) else {
            return
        }
        
        guard await shouldFetch(for: nextPath) else {
            return
        }
        
        let request = CollectionRequest(
            involvedMaker: involvedMaker,
            resultsPerPage: resultsPerPage,
            page: nextPath
        )
        try await fetchCollection(for: request)
    }
}

private extension OverviewInteractor {
    func page(for index: Int) -> Int {
        let pageFraction = Double(index + 1) / Double(resultsPerPage)
        let page = Int(floor(pageFraction))
        return page
    }
    
    var largestTotalCount: Int? {
        get async {
            await collectionPageResponse.responses.compactMap { $0.value?.count }.max()
        }
    }
    
    var numberOfPages: Int? {
        get async {
            guard let largestTotalCount = await largestTotalCount else {
                return nil
            }

            let pageFraction = Double(largestTotalCount) / Double(resultsPerPage)
            let pages = Int(ceil(pageFraction))
            return pages
        }
    }
    
    func pageToFetchAfter(index: Int) async -> Int? {
        guard let numberOfPages = await numberOfPages else {
            return nil
        }

        let pageFraction = Double(index + firstPageIndex) / Double(resultsPerPage)
        let page = Int(floor(pageFraction))
        
        let nextPage = page + 1
        guard nextPage <= numberOfPages else {
            return nil
        }
        return nextPage
    }
    
    func shouldFetch(for page: Int) async -> Bool {
        await collectionPageResponse.contains(page: page) == false
    }
}

private extension OverviewInteractor {
    func fetchCollection(for collectionRequest: CollectionRequest) async throws {
        await collectionPageResponse.set(page: collectionRequest.page, response: nil)
        await presenter.willFetchCollection()
        
        do {
            let collection = try await collectionWorker.collection(for: collectionRequest)
            await collectionPageResponse.set(page: collectionRequest.page, response: collection)
            await presenter.didFetch(responses: collectionPageResponse.responses)
        } catch {
            await collectionPageResponse.remove(page: collectionRequest.page)
            
            await presenter.failedFetchCollection(with: error)
            throw error
        }
    }
}
