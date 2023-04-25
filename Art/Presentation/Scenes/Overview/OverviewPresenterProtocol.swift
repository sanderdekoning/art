//
//  OverviewPresenterProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import UIKit

protocol OverviewPresenterProtocol: AnyObject {
    func setup(cell: OverviewViewCell, with art: Art, thumbnail: UIImage) async throws
    
    func willLoadInitialData()
    func didLoadInitialData(responseStore: CollectionPageResponseStoreProtocol) async
    func failedLoadInitialData(with error: Error)
    
    func willFetchCollection()
    func failedFetchCollection(with error: Error)
    func present(responseStore: CollectionPageResponseStoreProtocol) async
}
