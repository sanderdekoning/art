//
//  DetailConfigurator.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

@MainActor
enum DetailConfigurator {
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
            imageService: ImageService(
                worker: ImageWorker(session: .shared),
                thumbnailCache: SharedCache.defaultURLRequestThumbnail,
                thumbnailSize: CGSize(width: 1200, height: 1200)
            )
        )
    }
}
