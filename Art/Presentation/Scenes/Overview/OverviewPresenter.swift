//
//  OverviewPresenter.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import Foundation

@MainActor protocol OverviewPresenterProtocol: AnyObject {
    func willFetchCollection()
    func didFetch(collection: CollectionResponse)
}

class OverviewPresenter {
    weak var output: OverviewPresenterOutputProtocol?
    
    init(output: any OverviewPresenterOutputProtocol) {
        self.output = output
    }
}

@MainActor extension OverviewPresenter: OverviewPresenterProtocol {
    func willFetchCollection() {
        output?.willRetrieveCollection()
    }
    
    func didFetch(collection: CollectionResponse) {
        output?.didRetrieve(art: collection.artObjects)
    }
}

@MainActor protocol OverviewPresenterOutputProtocol: AnyObject {
    func willRetrieveCollection()
    func didRetrieve(art: [Art])
}
