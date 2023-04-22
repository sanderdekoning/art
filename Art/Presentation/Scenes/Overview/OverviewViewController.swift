//
//  ViewController.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

class OverviewViewController: UIViewController {
    var dataSource: OverviewViewDataSource?
    var overviewView: OverviewView?
    var interactor: OverviewInteractor?
    var router: OverviewRouter?

    let involvedMaker = "Vincent van Gogh"

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
        title = involvedMaker

        overviewView?.delegate = self
        
        overviewView?.refreshControl?.addAction(refreshAction, for: .primaryActionTriggered)
    }
}

private extension OverviewViewController {
    func refresh() {
        Task(priority: .userInitiated) {
            do {
                try await interactor?.refresh(with: involvedMaker)
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

extension OverviewViewController: UICollectionViewDelegate {
    // FIXME: There is a known scenario where willDisplay does not get called after applying a
    // snapshot if pagination page size is smaller or equal to number of items that fit on screen
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        Task(priority: .userInitiated) {
            do {
                try await interactor?.willDisplayArt(at: indexPath, forInvolvedMaker: involvedMaker)
            } catch {
                // TODO: handle pagination fetch collection error
                print(error)
            }
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
    
    func display(art: [Art]) async {
        await dataSource?.update(to: art, animated: true)
        overviewView?.endRefreshing()
    }
}
