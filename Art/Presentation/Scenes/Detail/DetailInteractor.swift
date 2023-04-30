//
//  DetailInteractor.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import Foundation

class DetailInteractor {
    var art: Art

    private let presenter: DetailPresenterProtocol
    private let imageWorker: ImageWorkerProtocol

    init(
        art: Art,
        presenter: any DetailPresenterProtocol,
        imageWorker: any ImageWorkerProtocol
    ) {
        self.art = art
        self.presenter = presenter
        self.imageWorker = imageWorker
    }
}

extension DetailInteractor: DetailInteractorProtocol {
    func loadArt() async throws {
        let image = try await imageWorker.image(from: art.webImage.url, prefersThumbnail: false)
        await presenter.show(image: image)
    }
}
