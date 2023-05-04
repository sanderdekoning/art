//
//  OverviewRouter.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

class OverviewRouter: OverviewRouterProtocol {
    weak var navigationController: UINavigationController?

    let imageWorker: ImageWorkerProtocol

    init(imageWorker: some ImageWorkerProtocol) {
        self.imageWorker = imageWorker
    }

    @MainActor
    func showDetail(for art: Art) async {
        guard let thumbnailImage = await imageWorker.cachedThumbnail(from: art.webImage.url) else {
            return
        }

        let detailViewController = DetailViewController()
        DetailConfigurator.configureScene(
            viewController: detailViewController,
            art: art,
            thumbnailImage: thumbnailImage
        )
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
