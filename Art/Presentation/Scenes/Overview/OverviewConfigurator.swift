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
        let interactor = OverviewInteractor(presenter: presenter)

        let router = OverviewRouter()
        router.navigationController = viewController.navigationController

        viewController.overviewView = view
        viewController.router = router
        viewController.interactor = interactor
    }
}
