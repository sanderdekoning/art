//
//  OverviewViewDataSource.swift
//  Art
//
//  Created by Sander de Koning on 22/04/2023.
//

import UIKit

@MainActor protocol OverviewViewDataSourceProtocol {
    func update(to art: [Art], animated: Bool) async
}

@MainActor class OverviewViewDataSource {
    let diffable: UICollectionViewDiffableDataSource<Section, Art>
    
    private typealias CellRegistration = UICollectionView.CellRegistration<OverviewViewCell, Art>
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Art>
    
    init(collectionView: UICollectionView, imageWorker: any ImageWorkerProtocol) {
        let cellRegistration = CellRegistration { cell, _, art in
            cell.setup(with: art.webImage.url, worker: imageWorker)
        }
        
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
    func update(to art: [Art], animated: Bool = true) async {
        var snapshot = diffable.snapshot()
        
        // Add the sections if not present yet
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections(Section.allCases)
        }
        
        // Append items not present in the current snapshot
        let appendItems = art.filter { !snapshot.itemIdentifiers.contains($0) }
        snapshot.appendItems(appendItems, toSection: .art)
        
        // Delete items not present in the new art
        let deleteItems = snapshot.itemIdentifiers.filter { !art.contains($0) }
        snapshot.deleteItems(deleteItems)
        
        // Ensure we maintain correct order after appending and deleting items
        var previousArt: Art?
        art.forEach { art in
            if let previousArt {
                snapshot.moveItem(art, afterItem: previousArt)
            }
            
            previousArt = art
        }

        await diffable.apply(snapshot, animatingDifferences: animated)
    }
}

extension OverviewViewDataSource {
    enum Section: Int, CaseIterable {
        case art
    }
}
