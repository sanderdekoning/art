//
//  OverviewConfigurator.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

@MainActor class OverviewConfigurator {
    static func configureScene(viewController: OverviewViewController) {
        let view = OverviewView()
        let presenter = OverviewPresenter(output: viewController)
        
        let collectionWorker = CollectionWorker(session: .shared)
        let pageResponse = CollectionPageResponse()
        let paginationConfig = OverviewInteractorPaginationConfig()
        let interactor = OverviewInteractor(
            presenter: presenter,
            collectionWorker: collectionWorker,
            collectionPageResponse: pageResponse,
            paginationConfig: paginationConfig
        )

        let imageWorker = ImageWorker(
            session: .shared,
            artImageCache: .artImageCache,
            artImageThumbnailCache: .artImageThumbnailCache
        )
        let dataSource = OverviewViewDataSource(collectionView: view, imageWorker: imageWorker)
        
        let router = OverviewRouter()
        router.navigationController = viewController.navigationController

        viewController.dataSource = dataSource
        viewController.overviewView = view
        viewController.router = router
        viewController.interactor = interactor
    }
}
