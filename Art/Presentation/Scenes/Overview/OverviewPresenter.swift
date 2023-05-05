//
//  OverviewPresenter.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

struct OverviewPresenter {
    private weak var output: OverviewPresenterOutputProtocol?

    private var router: OverviewRouterProtocol
    private let collectionGroupKeyPath: KeyPath<Art, String> = \.principalOrFirstMaker

    init(router: some OverviewRouterProtocol, output: some OverviewPresenterOutputProtocol) {
        self.router = router
        self.output = output
    }
}

extension OverviewPresenter: OverviewPresenterProtocol {
    func setup(cell: OverviewViewCell, with art: Art, thumbnail: UIImage) async {
        let preparedThumbnail = await thumbnail.preparedForDisplay
        output?.setArtView(for: cell, with: art, thumbnail: preparedThumbnail ?? thumbnail)
    }

    func willLoadInitialData() {
        output?.willLoadInitialData()
    }

    func didLoadInitialData(responses: some Collection<CollectionPageResponse>) async {
        let dataSourceSnapshot = await dataSourceSnapshot(for: responses)
        output?.didLoadInitialData(dataSourceSnapshot: dataSourceSnapshot)
    }

    func failedLoadInitialData(with error: Error) {
        output?.failedLoadInitialData(with: error)
    }

    func showLoadingActivityView() {
        output?.showLoadingActivityView()
    }

    func removeLoadingActivityView() {
        output?.removeLoadingActivityView()
    }

    func present(responses: some Collection<CollectionPageResponse>) async {
        let dataSourceSnapshot = await dataSourceSnapshot(for: responses)
        await output?.display(dataSourceSnapshot: dataSourceSnapshot)
    }

    func showDetail(for art: Art, thumbnail: UIImage) async {
        await router.showDetail(for: art, thumbnail: thumbnail)
    }
}

private extension OverviewPresenter {
    func sortedArtByPage(responses: some Collection<CollectionPageResponse>) async -> [ArtPage] {
        let artPages = responses.sorted {
            $0.page < $1.page
        }.map { pageResponse in
            pageResponse.response.artObjects.map { art in
                ArtPage(art: art, page: pageResponse.page)
            }
        }.flatMap { $0 }

        return artPages
    }

    func dataSourceSnapshot(
        for artPages: [ArtPage],
        groupedByKeyPath: KeyPath<Art, String>
    ) -> NSDiffableDataSourceSnapshot<String, ArtPage> {
        var snapshot = NSDiffableDataSourceSnapshot<String, ArtPage>()

        artPages.forEach { artPage in
            let section = artPage.art[keyPath: groupedByKeyPath]
            if snapshot.sectionIdentifiers.contains(section) == false {
                snapshot.appendSections([section])
            }

            snapshot.appendItems([artPage], toSection: section)
        }

        return snapshot
    }

    func dataSourceSnapshot(
        for responses: some Collection<CollectionPageResponse>
    ) async -> NSDiffableDataSourceSnapshot<String, ArtPage> {
        let sortedArtByPage = await sortedArtByPage(responses: responses)
        let dataSourceSnapshot = dataSourceSnapshot(
            for: sortedArtByPage,
            groupedByKeyPath: collectionGroupKeyPath
        )
        return dataSourceSnapshot
    }
}
