//
//  OverviewRouter.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

struct OverviewRouter: OverviewRouterProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    @MainActor
    func showDetail(for art: Art, thumbnail: UIImage) async {
        let detailViewController = DetailViewController()
        DetailConfigurator.configureScene(
            viewController: detailViewController,
            art: art,
            thumbnailImage: thumbnail
        )

        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
