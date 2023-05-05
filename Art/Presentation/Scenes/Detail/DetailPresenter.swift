//
//  DetailPresenter.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

struct DetailPresenter {
    private let router: DetailRouterProtocol
    private weak var output: DetailPresenterOutputProtocol?

    init(router: some DetailRouterProtocol, output: some DetailPresenterOutputProtocol) {
        self.router = router
        self.output = output
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func didLoadArt(art: Art, image: UIImage) async {
        let preparedImage = await image.preparedForDisplay

        output?.apply(
            viewModel: DetailViewModel(image: preparedImage ?? image, title: art.longTitle)
        )
    }

    func failedLoadArt(with error: Error) {
        // TODO: determine load art error
    }
}
