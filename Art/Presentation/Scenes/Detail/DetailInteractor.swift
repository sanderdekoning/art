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
    private let imageService: ImageServiceProtocol

    init(
        art: Art,
        presenter: some DetailPresenterProtocol,
        imageService: some ImageServiceProtocol
    ) {
        self.art = art
        self.presenter = presenter
        self.imageService = imageService
    }
}

extension DetailInteractor: DetailInteractorProtocol {
    func loadArt() async {
        do {
            // Present an existing cached thumbnail
            if let thumbnail = await imageService.cachedThumbnail(for: art.webImage.url) {
                await presenter.didLoadArt(art: art, image: thumbnail)
            }

            // Request and present the art image
            let image = try await imageService.image(
                from: art.webImage.url,
                prefersThumbnail: false
            )
            await presenter.didLoadArt(art: art, image: image)
        } catch {
            presenter.failedLoadArt(with: error)
        }
    }
}
