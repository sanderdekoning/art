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
        let collectionPageResponseStore = CollectionPageResponseStore()
        let collectionRequestsPending = CollectionRequestsPending()
        let paginationConfig = OverviewInteractorPaginationConfig()
        let interactor = OverviewInteractor(
            presenter: presenter,
            collectionWorker: collectionWorker,
            collectionPageResponseStore: collectionPageResponseStore,
            collectionRequestsPending: collectionRequestsPending,
            paginationConfig: paginationConfig
        )
        
        let router = OverviewRouter()
        router.navigationController = viewController.navigationController

        viewController.overviewView = view
        viewController.router = router
        viewController.interactor = interactor
    }
}
