//
//  DetailViewController.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

class DetailViewController: UIViewController {
    var detailView: DetailView?
    var interactor: DetailInteractor?

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsUpdateOfHomeIndicatorAutoHidden()

        Task {
            do {
                try await interactor?.loadArt()
            } catch {
                // TODO: handle load art error
            }
        }
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
}

extension DetailViewController: DetailPresenterOutputProtocol {
    nonisolated func show(image: UIImage) {
        Task { @MainActor in
            detailView?.updateImage(to: image)
        }
    }
}
