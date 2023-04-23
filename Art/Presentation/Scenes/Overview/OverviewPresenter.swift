//
//  OverviewPresenter.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

@MainActor protocol OverviewPresenterProtocol: AnyObject {
    func willFetchCollection()
    func failedFetchCollection(with error: Error)
    func didFetch(responseStore: CollectionPageResponseStoreProtocol) async
}

class OverviewPresenter {
    weak var output: OverviewPresenterOutputProtocol?
    
    private let collectionGroupKeyPath: KeyPath<Art, String> = \.principalOrFirstMaker
    
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
    
    func didFetch(responseStore: CollectionPageResponseStoreProtocol) async {
        let sortedArtByPage = await sortedArtByPage(responseStore: responseStore)
        let snapshot = dataSource(for: sortedArtByPage, groupedByKeyPath: collectionGroupKeyPath)
        await output?.display(dataSourceSnapshot: snapshot)
    }
}

private extension OverviewPresenter {
    func sortedArtByPage(responseStore: CollectionPageResponseStoreProtocol) async -> [ArtPage] {
        let responses = await responseStore.responses

        let artPages = Array(responses).sorted {
            $0.page < $1.page
        }.map { pageResponse in
            pageResponse.response.artObjects.map { art in
                ArtPage(art: art, page: pageResponse.page)
            }
        }.flatMap { $0 }
        
        return artPages
    }
    
    func dataSource(
        for artPages: [ArtPage],
        groupedByKeyPath: KeyPath<Art, String>
    ) -> NSDiffableDataSourceSnapshot<String, ArtPage> {
        var snapshot = NSDiffableDataSourceSnapshot<String, ArtPage>()
        
        artPages.forEach { artPage in
            let section = artPage.art[keyPath: groupedByKeyPath]
            if snapshot.sectionIdentifiers.contains(section) == false {
                snapshot.appendSections([section])
            }
            
            snapshot.appendItems([artPage], toSection: section)
        }
        
        return snapshot
    }
}

@MainActor protocol OverviewPresenterOutputProtocol: AnyObject {
    func willRetrieveCollection()
    func failedFetchCollection(with error: Error)
    func display(dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>) async
}