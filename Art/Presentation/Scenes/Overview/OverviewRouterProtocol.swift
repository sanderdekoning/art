//
//  OverviewRouterProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import UIKit

protocol OverviewRouterProtocol {
    @MainActor
    func showDetail(for art: Art, thumbnail: UIImage) async
}
