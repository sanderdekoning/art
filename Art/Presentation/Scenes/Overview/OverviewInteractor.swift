//
//  OverviewInteractor.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import Foundation

class OverviewInteractor {
    let presenter: OverviewPresenterProtocol
    
    private let collectionWorker: CollectionWorkerProtocol
    private let imageWorker: ImageWorkerProtocol
    private let collectionPageResponseStore: CollectionPageResponseStoreProtocol
    private let collectionRequestsPending: CollectionRequestsPendingProtocol
    private let paginationConfig: OverviewInteractorPaginationConfigProtocol
    
    init(
        presenter: any OverviewPresenterProtocol,
        collectionWorker: any CollectionWorkerProtocol,
        imageWorker: any ImageWorkerProtocol,
        collectionPageResponseStore: any CollectionPageResponseStoreProtocol,
        collectionRequestsPending: any CollectionRequestsPendingProtocol,
        paginationConfig: any OverviewInteractorPaginationConfigProtocol
    ) {
        self.presenter = presenter
        self.collectionWorker = collectionWorker
        self.imageWorker = imageWorker
        self.collectionPageResponseStore = collectionPageResponseStore
        self.collectionRequestsPending = collectionRequestsPending
        self.paginationConfig = paginationConfig
    }
}

extension OverviewInteractor: OverviewInteractorProtocol {
    func loadInitialData() async throws {
        do {
            if await shouldFetch(request: initialRequest) {
                presenter.willLoadInitialData()
                try await fetchCollection(for: initialRequest)
            }
            await presenter.didLoadInitialData(responseStore: collectionPageResponseStore)
        } catch {
            presenter.failedLoadInitialData(with: error)

            throw error
        }
    }
    
    func refresh() async throws {
        await collectionPageResponseStore.removeAll()
        await collectionRequestsPending.removeAll()
        
        try await fetchCollection(for: initialRequest)
        await presenter.present(responseStore: collectionPageResponseStore)
    }
    
    func willSetupCell(for artPage: ArtPage) async throws {
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
        guard await shouldFetch(request: nextPageRequest) else {
            return
        }
        
        try await fetchCollection(for: nextPageRequest)
        await presenter.present(responseStore: collectionPageResponseStore)
    }
    
    func setup(cell: OverviewViewCell, with art: Art) async throws {
        let thumbnail = try await imageWorker.image(
            from: art.webImage.url,
            prefersThumbnail: true
        )

        try Task.checkCancellation()
        
        try await presenter.setup(cell: cell, with: art, thumbnail: thumbnail)
    }
}

private extension OverviewInteractor {
    var initialRequest: CollectionRequest {
        CollectionRequest(
            resultsPerPage: paginationConfig.resultsPerPage,
            page: paginationConfig.firstPageIndex
        )
    }

    func shouldFetch(request: CollectionRequest) async -> Bool {
        let hasResponse = await collectionPageResponseStore.hasResponse(forPage: request.page)
        let isPendingResponse = await collectionRequestsPending.isPending(request: request)
        return hasResponse == false && isPendingResponse == false
    }
    
    func fetchCollection(for request: CollectionRequest) async throws {
        await collectionRequestsPending.add(request: request)
        presenter.willFetchCollection()
        
        do {
            let pageResponse = try await collectionWorker.collection(for: request)

            await collectionPageResponseStore.store(response: pageResponse)
        } catch {
            await collectionRequestsPending.remove(request: request)
            
            presenter.failedFetchCollection(with: error)
            throw error
        }
    }
}
