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
    
    private let collectionWorker: CollectionWorkerProtocol
    private let collectionPageResponse: CollectionPageResponseProtocol
    private let paginationConfig: OverviewInteractorPaginationConfigProtocol
    
    init(
        presenter: any OverviewPresenterProtocol,
        collectionWorker: any CollectionWorkerProtocol,
        collectionPageResponse: any CollectionPageResponseProtocol,
        paginationConfig: any OverviewInteractorPaginationConfigProtocol
    ) {
        self.presenter = presenter
        self.collectionWorker = collectionWorker
        self.collectionPageResponse = collectionPageResponse
        self.paginationConfig = paginationConfig
    }
}

extension OverviewInteractor: OverviewInteractorProtocol {
    func refresh(with involvedMaker: String) async throws {
        await collectionPageResponse.removeAll()
        
        let request = CollectionRequest(
            involvedMaker: involvedMaker,
            resultsPerPage: paginationConfig.resultsPerPage,
            page: paginationConfig.firstPageIndex
        )
        try await fetchCollection(for: request)
    }
    
    func willDisplayArt(at indexPath: IndexPath, for involvedMaker: String) async throws {
        guard let numberOfPages = await numberOfPages else {
            return
        }
        
        let index = indexPath.item
        let nextPage = paginationConfig.pageToFetchAfter(index: index, numberOfPages: numberOfPages)
        guard let nextPage else {
            return
        }
        
        guard await shouldFetch(page: nextPage, afterIndex: index) else {
            return
        }
        
        let request = CollectionRequest(
            involvedMaker: involvedMaker,
            resultsPerPage: paginationConfig.resultsPerPage,
            page: nextPage
        )
        try await fetchCollection(for: request)
    }
}

private extension OverviewInteractor {
    var largestTotalCount: Int? {
        get async {
            // Get the largest total count from all the collection responses
            await collectionPageResponse.responses.compactMap { $0.value?.count }.max()
        }
    }
    
    var numberOfPages: Int? {
        get async {
            guard let largestTotalCount = await largestTotalCount else {
                return nil
            }

            let pageFraction = Double(largestTotalCount) / Double(paginationConfig.resultsPerPage)
            let pages = Int(ceil(pageFraction))
            return pages
        }
    }
    
    func shouldFetch(page: Int, afterIndex index: Int) async -> Bool {
        guard await paginationConfig.shouldFetch(page: page, afterIndex: index) else {
            return false
        }

        return await collectionPageResponse.contains(page: page) == false
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
