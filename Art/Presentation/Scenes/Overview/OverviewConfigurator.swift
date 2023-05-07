//
//  OverviewConfigurator.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

@MainActor
enum OverviewConfigurator {
    static func configureScene(viewController: OverviewViewController) {
        viewController.interactor = OverviewInteractor(
            presenter: OverviewPresenter(
                router: OverviewRouter(navigationController: viewController.navigationController),
                output: viewController
            ),
            collectionService: CollectionService(
                statusStore: TaskStatusStore<CollectionRequest, CollectionPageResponse>(),
                worker: CollectionWorker(session: .shared)
            ),
            imageService: ImageService(
                worker: ImageWorker(session: .shared),
                thumbnailCache: SharedURLImageCache.defaultThumbnail,
                thumbnailSize: CGSize(width: 1200, height: 1200)
            ),
            paginationConfig: OverviewPaginationConfig()
        )
    }
}
