//
//  DetailConfigurator.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

@MainActor
class DetailConfigurator {
    static func configureScene(
        viewController: DetailViewController,
        art: Art,
        thumbnailImage: UIImage
    ) {
        let presenter = DetailPresenter(output: viewController)
        let imageWorker = ImageWorker.sharedDefaultThumbnail
        let interactor = DetailInteractor(art: art, presenter: presenter, imageWorker: imageWorker)

        let view = DetailView(thumbnailImage: thumbnailImage, title: art.title)

        let router = DetailRouter()
        router.navigationController = viewController.navigationController

        viewController.detailView = view
        viewController.router = router
        viewController.interactor = interactor
    }
}
