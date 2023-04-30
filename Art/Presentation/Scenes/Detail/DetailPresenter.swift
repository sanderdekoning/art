//
//  DetailPresenter.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

class DetailPresenter {
    weak var output: DetailPresenterOutputProtocol?

    init(output: any DetailPresenterOutputProtocol) {
        self.output = output
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func show(image: UIImage) async {
        let preparedImage = await image.preparedForDisplay
        output?.show(image: preparedImage ?? image)
    }
}
