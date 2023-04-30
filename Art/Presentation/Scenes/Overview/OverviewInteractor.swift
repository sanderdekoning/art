//
//  OverviewInteractor.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import Foundation

class OverviewInteractor {
    let presenter: OverviewPresenterProtocol

    private let collectionService: CollectionServiceProtocol
    private let imageWorker: ImageWorkerProtocol
    private let paginationConfig: OverviewInteractorPaginationConfigProtocol

    init(
        presenter: any OverviewPresenterProtocol,
        collectionService: any CollectionServiceProtocol,
        imageWorker: any ImageWorkerProtocol,
        paginationConfig: any OverviewInteractorPaginationConfigProtocol
    ) {
        self.presenter = presenter
        self.collectionService = collectionService
        self.imageWorker = imageWorker
        self.paginationConfig = paginationConfig
    }
}

extension OverviewInteractor: OverviewInteractorProtocol {
    func loadInitialData() async throws {
        do {
            if await shouldFetch(request: initialRequest) {
                presenter.willLoadInitialData()
                _ = try await collectionService.fetch(request: initialRequest)
            }
            await presenter.didLoadInitialData(responses: collectionService.statusStore.responses)
        } catch {
            presenter.failedLoadInitialData(with: error)

            throw error
        }
    }

    func refresh() async throws {
        await collectionService.statusStore.removeAll()

        _ = try await collectionService.fetch(request: initialRequest)
        await presenter.present(responses: collectionService.statusStore.responses)

        presenter.removeLoadingActivityView()
    }

    func willSetupCell(for artPage: ArtPage) async throws {
        try await fetchNextPageIfNeeded(afterPage: artPage.page)
    }

    func willDisplayLastCell() async throws {
        guard let maxPageResponse = await maxPageResponse else {
            return
        }

        try await fetchNextPageIfNeeded(afterPage: maxPageResponse)
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

    var maxPageResponse: Int? {
        get async {
            await collectionService.statusStore.responses.map(\.page).max()
        }
    }

    var maxResponseTotalCount: Int? {
        get async {
            // Get the largest total count from all the responses
            await collectionService.statusStore.responses.map(\.response.count).max()
        }
    }

    func shouldFetch(request: CollectionRequest) async -> Bool {
        let didRequest = await collectionService.statusStore.didRequest(request: request)
        return didRequest == false
    }

    func fetchNextPageIfNeeded(afterPage page: Int) async throws {
        guard let totalPages = await maxResponseTotalCount else {
            return
        }

        guard let nextPage = paginationConfig.pageToFetchAfter(
            page: page,
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

        presenter.showLoadingActivityView()

        _ = try await collectionService.fetch(request: nextPageRequest)
        await presenter.present(responses: collectionService.statusStore.responses)

        await updateActivityViews()
    }

    func updateActivityViews() async {
        if await collectionService.statusStore.hasInProgress {
            presenter.showLoadingActivityView()
        } else {
            presenter.removeLoadingActivityView()
        }
    }
}
