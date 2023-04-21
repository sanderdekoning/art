//
//  OverviewView.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

class OverviewView: UICollectionView {
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, Art> = {
        let registration = UICollectionView.CellRegistration<OverviewViewCell, Art>{ cell, _, art in
            cell.setup(with: art)
        }

        return UICollectionViewDiffableDataSource(
            collectionView: self
        ) { collectionView, indexPath, art in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: art
            )
        }
    }()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: .art)
        
        setupViews()
    }
    
    @available(* , unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginRefreshing(wantsRefreshControlVisible: Bool = true) {
        guard let refreshControl, !refreshControl.isRefreshing else {
            return
        }
        
        refreshControl.beginRefreshing()
        
        if wantsRefreshControlVisible {
            scrollRectToVisible(refreshControl.frame, animated: true)
        }
    }
    
    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
    
    func setupViews() {
        alwaysBounceVertical = true
        
        dataSource = diffableDataSource
        
        refreshControl = UIRefreshControl()
    }
    
    func setupDataSource(art: [Art]) {
        var snapshot = NSDiffableDataSourceSnapshot<OverviewView.Section, Art>()
        snapshot.appendSections(OverviewView.Section.allCases)
        snapshot.appendItems(art, toSection: .art)
        diffableDataSource.applySnapshotUsingReloadData(snapshot)
    }
}

extension OverviewView {
    enum Section: Int, CaseIterable {
        case art
    }
}
