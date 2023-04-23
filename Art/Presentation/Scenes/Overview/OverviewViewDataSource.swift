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
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<String, ArtPage>

    init(
        collectionView: UICollectionView,
        cellRegistration: CellRegistration
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
