//
//  OverviewViewDataSource.swift
//  Art
//
//  Created by Sander de Koning on 22/04/2023.
//

import UIKit

@MainActor class OverviewViewDataSource {
    private let diffable: DiffableDataSource
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<String, ArtPage>

    typealias CellRegistration = UICollectionView.CellRegistration<OverviewViewCell, ArtPage>
    typealias HeaderViewRegistration = UICollectionView.SupplementaryRegistration<OverviewViewHeader>

    init(
        collectionView: UICollectionView,
        cellRegistration: CellRegistration,
        supplementaryViewRegistration: HeaderViewRegistration
    ) {
        let cellProvider: DiffableDataSource.CellProvider = { collectionView, indexPath, art in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: art
            )
        }

        diffable = DiffableDataSource(
            collectionView: collectionView,
            cellProvider: cellProvider
        )

        let supplementaryProvider: DiffableDataSource.SupplementaryViewProvider = {
            collectionView, elementKind, indexPath in

            guard elementKind == UICollectionView.elementKindSectionHeader else {
                return nil
            }

            return collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryViewRegistration,
                for: indexPath
            )
        }

        diffable.supplementaryViewProvider = supplementaryProvider

        collectionView.dataSource = diffable
    }
}

extension OverviewViewDataSource {
    func update(
        to dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>,
        animated: Bool
    ) async {
        await diffable.apply(dataSourceSnapshot, animatingDifferences: animated)
    }

    func snapshot() -> NSDiffableDataSourceSnapshot<String, ArtPage> {
        diffable.snapshot()
    }

    func artPage(for indexPath: IndexPath) -> ArtPage? {
        diffable.itemIdentifier(for: indexPath)
    }

    func artPageIsLastItem(artPage: ArtPage) -> Bool {
        let artPages = snapshot().itemIdentifiers

        guard let lastPage = artPages.last else {
            // Defaulting to true if the current index is not in the snapshot
            return true
        }

        return artPage == lastPage
    }
}
