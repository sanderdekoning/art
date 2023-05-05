//
//  DetailConfigurator.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

@MainActor
struct DetailConfigurator {
    static func configureScene(
        viewController: DetailViewController,
        art: Art,
        thumbnailImage: UIImage
    ) {
        viewController.interactor = DetailInteractor(
            art: art,
            presenter: DetailPresenter(
                router: DetailRouter(navigationController: viewController.navigationController),
                output: viewController
            ),
            imageWorker: SharedImageWorker.defaultThumbnails
        )
    }
}
