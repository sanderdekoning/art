//
//  OverviewPresenter.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import Foundation

@MainActor protocol OverviewPresenterProtocol: AnyObject {
    func willFetchCollection()
    func failedFetchCollection(with error: Error)
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
    
    func failedFetchCollection(with error: Error) {
        output?.failedFetchCollection(with: error)
    }
    
    func didFetch(collection: CollectionResponse) {
        output?.didRetrieve(art: collection.artObjects)
    }
}

@MainActor protocol OverviewPresenterOutputProtocol: AnyObject {
    func willRetrieveCollection()
    func failedFetchCollection(with error: Error)
    func didRetrieve(art: [Art])
}
