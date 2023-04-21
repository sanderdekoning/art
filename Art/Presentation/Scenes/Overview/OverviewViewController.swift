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

    let involvedMaker = "Vincent van Gogh"

    override func loadView() {
        super.loadView()

        view = overviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        retrieveCollection(of: involvedMaker)
    }

    func setupViews() {
        title = involvedMaker

        overviewView?.refreshControl?.addAction(refreshAction, for: .primaryActionTriggered)
    }
}

private extension OverviewViewController {
    func retrieveCollection(of involvedMaker: String) {
        Task(priority: .userInitiated) {
            do {
                try await interactor?.retrieveCollection(of: involvedMaker)
            } catch {
                // TODO: handle retrieve collection error
                print(error)
            }
        }
    }

    var refreshAction: UIAction {
        UIAction { [unowned self] _ in
            retrieveCollection(of: involvedMaker)
        }
    }
}

extension OverviewViewController: OverviewPresenterOutputProtocol {
    func willRetrieveCollection() {
        // TODO: determine whether we want to always scroll to top on refreshes
        overviewView?.beginRefreshing(wantsRefreshControlVisible: true)
    }

    func failedFetchCollection(with error: Error) {
        overviewView?.endRefreshing()
    }
    
    func didRetrieve(art: [Art]) {
        overviewView?.setupDataSource(art: art)
        overviewView?.endRefreshing()
    }
}
