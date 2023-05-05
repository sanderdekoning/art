//
//  OverviewConfigurator.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

@MainActor
struct OverviewConfigurator {
    static func configureScene(viewController: OverviewViewController) {
        viewController.overviewView = OverviewView()

        viewController.interactor = OverviewInteractor(
            presenter: OverviewPresenter(
                router: OverviewRouter(navigationController: viewController.navigationController),
                output: viewController
            ),
            collectionService: CollectionService(
                statusStore: TaskStatusStore<CollectionRequest, CollectionPageResponse>(),
                worker: CollectionWorker(session: .shared)
            ),
            imageWorker: SharedImageWorker.defaultThumbnails,
            paginationConfig: OverviewPaginationConfig()
        )
    }
}
