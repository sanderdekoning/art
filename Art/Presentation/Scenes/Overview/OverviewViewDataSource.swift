//
//  OverviewViewDataSource.swift
//  Art
//
//  Created by Sander de Koning on 22/04/2023.
//

import UIKit

@MainActor protocol OverviewViewDataSourceProtocol {
    func update(
        to dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>,
        animated: Bool
    ) async
}

@MainActor class OverviewViewDataSource {
    let diffable: UICollectionViewDiffableDataSource<String, ArtPage>
    
    typealias CellRegistration = UICollectionView.CellRegistration<OverviewViewCell, ArtPage>
    typealias HeaderViewRegistration = UICollectionView.SupplementaryRegistration<OverviewViewHeader>
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<String, ArtPage>

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

extension OverviewViewDataSource: OverviewViewDataSourceProtocol {
    func update(
        to dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>,
        animated: Bool
    ) async {
        await diffable.apply(dataSourceSnapshot, animatingDifferences: animated)
    }
}
