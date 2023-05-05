//
//  DetailPresenter.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

struct DetailPresenter {
    private var router: DetailRouterProtocol
    private weak var output: DetailPresenterOutputProtocol?

    init(router: some DetailRouterProtocol, output: some DetailPresenterOutputProtocol) {
        self.router = router
        self.output = output
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func show(image: UIImage) async {
        let preparedImage = await image.preparedForDisplay
        output?.show(image: preparedImage ?? image)
    }
}
