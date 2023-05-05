//
//  OverviewPresenterProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import UIKit

protocol OverviewPresenterProtocol {
    func setup(cell: OverviewViewCell, with art: Art, thumbnail: UIImage) async throws

    func willLoadInitialData()
    func didLoadInitialData(responses: some Collection<CollectionPageResponse>) async
    func failedLoadInitialData(with error: Error)

    func present(responses: some Collection<CollectionPageResponse>) async

    func showLoadingActivityView()
    func removeLoadingActivityView()

    func showDetail(for art: Art, thumbnail: UIImage) async
}
