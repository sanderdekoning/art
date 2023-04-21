//
//  OverviewRouter.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

protocol OverviewRouterProtocol {
    var navigationController: UINavigationController? { get }
}

class OverviewRouter: OverviewRouterProtocol {
    weak var navigationController: UINavigationController?
}
