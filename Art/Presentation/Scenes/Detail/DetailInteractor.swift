//
//  DetailInteractor.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import Foundation

struct DetailInteractor {
    private let art: Art
    private let presenter: DetailPresenterProtocol
    private let imageWorker: ImageWorkerProtocol

    init(
        art: Art,
        presenter: some DetailPresenterProtocol,
        imageWorker: some ImageWorkerProtocol
    ) {
        self.art = art
        self.presenter = presenter
        self.imageWorker = imageWorker
    }
}

extension DetailInteractor: DetailInteractorProtocol {
    func loadArt() async {
        do {
            let image = try await imageWorker.image(from: art.webImage.url, prefersThumbnail: false)
            await presenter.didLoadArt(art: art, image: image)
        } catch {
            presenter.failedLoadArt(with: error)
        }
    }
}
