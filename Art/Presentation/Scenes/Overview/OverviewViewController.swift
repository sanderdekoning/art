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
    { [weak self] cell, _, artPage in
        cell.setup(with: artPage.art, worker: ImageWorker.sharedThumbnail)
        
        Task {
            do {
                try await self?.interactor?.didSetupCell(for: artPage)
            } catch {
                // TODO: handle pagination fetch collection error
            }
        }
    }
    
    private lazy var sectionHeaderProvider = OverviewViewDataSource.HeaderViewRegistration(
        elementKind: UICollectionView.elementKindSectionHeader
    ) { [weak self] headerView, _, indexPath in
        let dataSourceSnapshot = self?.dataSource?.diffable.snapshot()
        let headerItem = dataSourceSnapshot?.sectionIdentifiers[indexPath.section]
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
        view = overviewView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        loadInitialData()
    }

    func setupViews() {
        title = NSLocalizedString("Art", comment: "")
        
        overviewView?.refreshControl?.addAction(refreshAction, for: .primaryActionTriggered)
    }
}

private extension OverviewViewController {
    func loadInitialData() {
        Task(priority: .userInitiated) {
            do {
                try await interactor?.loadInitialData()
            } catch {
                // TODO: determine intial data load failure scenario
            }
        }
    }
    
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
    func willLoadInitialData() {
        overviewView?.beginRefreshing()
    }
    
    func didLoadInitialData(
        dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>
    ) async {
        await dataSource?.update(to: dataSourceSnapshot, animated: true)
        overviewView?.endRefreshing()
    }
    
    func failedLoadInitialData(with error: Error) {
        overviewView?.endRefreshing()
    }
    
    func willRetrieveCollection() {
        showLoadingActivity()
    }

    func failedFetchCollection(with error: Error) {
        hideLoadingActivity()
    }

    func display(dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>) async {
        await dataSource?.update(to: dataSourceSnapshot, animated: true)
        hideLoadingActivity()
    }
}

extension OverviewViewController {
    func showLoadingActivity() {
        guard navigationItem.rightBarButtonItem == nil else {
            return
        }
        
        let acitivityIndicatorView = UIActivityIndicatorView()
        acitivityIndicatorView.hidesWhenStopped = true
        acitivityIndicatorView.startAnimating()
        
        let button = UIBarButtonItem(customView: acitivityIndicatorView)
        
        navigationItem.rightBarButtonItem = button
    }
    
    func hideLoadingActivity() {
        navigationItem.rightBarButtonItem = nil
        
        overviewView?.endRefreshing()
    }
}
