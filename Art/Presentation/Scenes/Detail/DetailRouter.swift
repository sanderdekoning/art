//
//  DetailRouter.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

protocol DetailRouterProtocol {
    var navigationController: UINavigationController? { get }
}

class DetailRouter: DetailRouterProtocol {
    weak var navigationController: UINavigationController?
}
