//
//  OverviewInteractor.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import Foundation

protocol OverviewInteractorProtocol: AnyObject {
    func refresh() async throws
    func didSetupCell(for artPage: ArtPage, at indexPath: IndexPath) async throws
}

class OverviewInteractor {
    let presenter: OverviewPresenterProtocol
    
    private let collectionWorker: CollectionWorkerProtocol
    private var collectionPageResponseStore: CollectionPageResponseStoreProtocol
    private var collectionRequestsPending: CollectionRequestsPendingProtocol
    private let paginationConfig: OverviewInteractorPaginationConfigProtocol
    
    init(
        presenter: any OverviewPresenterProtocol,
        collectionWorker: any CollectionWorkerProtocol,
        collectionPageResponseStore: any CollectionPageResponseStoreProtocol,
        collectionRequestsPending: any CollectionRequestsPendingProtocol,
        paginationConfig: any OverviewInteractorPaginationConfigProtocol
    ) {
        self.presenter = presenter
        self.collectionWorker = collectionWorker
        self.collectionPageResponseStore = collectionPageResponseStore
        self.collectionRequestsPending = collectionRequestsPending
        self.paginationConfig = paginationConfig
    }
}

extension OverviewInteractor: OverviewInteractorProtocol {
    func refresh() async throws {
        await collectionPageResponseStore.removeAll()
        await collectionRequestsPending.removeAll()
        
        let request = CollectionRequest(
            resultsPerPage: paginationConfig.resultsPerPage,
            page: paginationConfig.firstPageIndex
        )
        try await fetchCollection(for: request)
    }
    
    func didSetupCell(for artPage: ArtPage, at indexPath: IndexPath) async throws {
        guard let totalPages = await collectionPageResponseStore.maxResponseTotalCount else {
            return
        }

        guard let nextPage = paginationConfig.pageToFetchAfter(
            page: artPage.page,
            numberOfPages: totalPages
        ) else {
            return
        }

        let nextPageRequest = CollectionRequest(
            resultsPerPage: paginationConfig.resultsPerPage,
            page: nextPage
        )
        guard await shouldFetch(request: nextPageRequest, afterIndex: indexPath.item) else {
            return
        }
        
        try await fetchCollection(for: nextPageRequest)
    }
}

private extension OverviewInteractor {
    func shouldFetch(request: CollectionRequest, afterIndex index: Int) async -> Bool {
        let hasResponse = await collectionPageResponseStore.hasResponse(forPage: request.page)
        let isPendingResponse = await collectionRequestsPending.isPending(request: request)
        return hasResponse == false && isPendingResponse == false
    }
    
    func fetchCollection(for request: CollectionRequest) async throws {
        await collectionRequestsPending.add(request: request)
        await presenter.willFetchCollection()
        
        do {
            let pageResponse = try await collectionWorker.collection(for: request)

            await collectionPageResponseStore.store(response: pageResponse)
            await presenter.didFetch(responseStore: collectionPageResponseStore)
        } catch {
            await collectionRequestsPending.remove(request: request)
            
            await presenter.failedFetchCollection(with: error)
            throw error
        }
    }
}