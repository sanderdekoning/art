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
    func didFetch(responses: [Int: CollectionResponse?])
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
    
    func didFetch(responses: [Int: CollectionResponse?]) {
        let art = responses.sorted {
            $0.key < $1.key
        }.compactMap {
            $0.value?.artObjects
        }.flatMap { $0 }

        output?.display(art: art)
    }
}

@MainActor protocol OverviewPresenterOutputProtocol: AnyObject {
    func willRetrieveCollection()
    func failedFetchCollection(with error: Error)
    func display(art: [Art])
}
