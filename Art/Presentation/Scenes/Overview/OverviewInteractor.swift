//
//  OverviewInteractor.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import Foundation

protocol OverviewInteractorProtocol: AnyObject {
    func retrieveCollection(of involvedMaker: String) async throws
}

class OverviewInteractor {
    let presenter: OverviewPresenterProtocol
    
    let collectionWorker = CollectionWorker()
    
    init(presenter: any OverviewPresenterProtocol) {
        self.presenter = presenter
    }
}

extension OverviewInteractor: OverviewInteractorProtocol {
    func retrieveCollection(of involvedMaker: String) async throws {
        try await fetchCollection(of: involvedMaker)
    }
}

private extension OverviewInteractor {
    func fetchCollection(of involvedMaker: String) async throws {
        await presenter.willFetchCollection()
        let collection = try await collectionWorker.collection(of: involvedMaker)
        await presenter.didFetch(collection: collection)
    }
}
