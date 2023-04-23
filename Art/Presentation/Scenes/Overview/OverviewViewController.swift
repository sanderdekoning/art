//
//  ViewController.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

class OverviewViewController: UIViewController {
    var overviewView: OverviewView?
    var interactor: OverviewInteractor?
    var router: OverviewRouter?
    
    private lazy var cellRegistration = OverviewViewDataSource.CellRegistration
    { [weak self] cell, indexPath, artPage in
        cell.setup(with: artPage.art.webImage.url, worker: ImageWorker.sharedThumbnail)
        
        Task(priority: .userInitiated) {
            do {
                try await self?.interactor?.didSetupCell(for: artPage, at: indexPath)
            } catch {
                // TODO: handle pagination fetch collection error
                print(error)
            }
        }
    }
    
    private lazy var sectionHeaderProvider = OverviewViewDataSource.SupplementaryViewRegistration(
        elementKind: UICollectionView.elementKindSectionHeader
    ) { [weak self] headerView, _, indexPath in
        let headerItem = self?.dataSource?.diffable.snapshot().sectionIdentifiers[indexPath.section]
        headerView.setup(withTitle: headerItem)
    }

    private lazy var dataSource: OverviewViewDataSource? = {
        guard let overviewView else {
            return nil
        }
        
        return OverviewViewDataSource(
            collectionView: overviewView,
            cellRegistration: cellRegistration,
            supplementaryViewRegistration: sectionHeaderProvider
        )
    }()
    
    override func loadView() {
        super.loadView()

        view = overviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        refresh()
    }

    func setupViews() {
        title = NSLocalizedString("Art", comment: "")
        
        overviewView?.refreshControl?.addAction(refreshAction, for: .primaryActionTriggered)
    }
}

private extension OverviewViewController {
    func refresh() {
        Task(priority: .userInitiated) {
            do {
                try await interactor?.refresh()
            } catch {
                // TODO: determine refresh failure scenario
            }
        }
    }
    
    var refreshAction: UIAction {
        UIAction { [unowned self] _ in
            refresh()
        }
    }
}

extension OverviewViewController: OverviewPresenterOutputProtocol {
    func willRetrieveCollection() {
        // TODO: determine whether we want to always scroll to top on refreshes
        overviewView?.beginRefreshing(wantsRefreshControlVisible: false)
    }

    func failedFetchCollection(with error: Error) {
        overviewView?.endRefreshing()
    }

    func display(dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>) async {
        await dataSource?.update(to: dataSourceSnapshot, animated: true)
        overviewView?.endRefreshing()
    }
}
