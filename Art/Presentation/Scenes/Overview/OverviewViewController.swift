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

        Task(priority: .userInitiated) {
            do {
                try await interactor?.retrieveCollection(of: involvedMaker)
            } catch {
                // TODO: handle retrieve collection error
                print(error)
            }
        }
    }
    
    func setupViews() {
        title = involvedMaker
    }
}

extension OverviewViewController: OverviewPresenterOutputProtocol {
    func willRetrieveCollection() {
        // TODO: show loading indicator
    }
    
    func didRetrieve(art: [Art]) {
        overviewView?.setupDataSource(art: art)
    }
}
