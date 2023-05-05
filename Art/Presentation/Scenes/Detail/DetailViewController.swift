//
//  DetailViewController.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

class DetailViewController: UIViewController {
    private weak var detailView: DetailView?
    var interactor: DetailInteractor?

    override func loadView() {
        let detailView = DetailView()
        view = detailView

        self.detailView = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    private func setupViews() {
        setNeedsUpdateOfHomeIndicatorAutoHidden()

        Task {
            await interactor?.loadArt()
        }
    }
}

extension DetailViewController: DetailPresenterOutputProtocol {
    nonisolated func apply(viewModel: DetailViewModel) {
        Task { @MainActor in
            detailView?.apply(viewModel: viewModel)
        }
    }
}
