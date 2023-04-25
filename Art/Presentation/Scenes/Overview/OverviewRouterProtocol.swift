//
//  OverviewRouterProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import UIKit

protocol OverviewRouterProtocol {
    var navigationController: UINavigationController? { get }
    
    @MainActor func showDetail(for art: Art) async
}
