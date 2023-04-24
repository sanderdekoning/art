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
        Task {
            do {
                try await self?.interactor?.willSetupCell(for: artPage)
            } catch {
                // TODO: handle pagination fetch collection error
            }
        }
        
        let cellTask = Task(priority: .userInitiated) { [weak self, weak cell] in
            guard let self, let cell else {
                return
            }

            do {
                try await self.interactor?.setup(cell: cell, with: artPage.art)
            } catch {
                // TODO: handle cell setup error
            }
        }
        cell.setup(with: cellTask)
    }
    
    private lazy var sectionHeaderProvider = OverviewViewDataSource.HeaderViewRegistration(
        elementKind: UICollectionView.elementKindSectionHeader
    ) { [weak self] headerView, _, indexPath in
        let dataSourceSnapshot = self?.dataSource?.snapshot()
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
        
        overviewView?.delegate = self
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

extension OverviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let artPage = dataSource?.artPage(for: indexPath) else {
            return
        }
        
        router?.showDetail(for: artPage.art)
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
    nonisolated func setArtView(for cell: OverviewViewCell, with art: Art, thumbnail: UIImage) {
        Task { @MainActor in
            cell.setArtView(for: art, image: thumbnail)
        }
    }
    
    nonisolated func willLoadInitialData() {
        Task { @MainActor in
            overviewView?.beginRefreshing()
        }
    }
    
    nonisolated func didLoadInitialData(
        dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>
    ) {
        Task { @MainActor in
            await dataSource?.update(to: dataSourceSnapshot, animated: true)
            overviewView?.endRefreshing()
        }
    }
    
    nonisolated func failedLoadInitialData(with error: Error) {
        Task { @MainActor in
            overviewView?.endRefreshing()
        }
    }
    
    nonisolated func willRetrieveCollection() {
        Task { @MainActor in
            showLoadingActivity()
        }
    }

    nonisolated func failedFetchCollection(with error: Error) {
        Task { @MainActor in
            hideLoadingActivity()
        }
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
