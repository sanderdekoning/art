//
//  OverviewPresenterOutputProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import UIKit

protocol OverviewPresenterOutputProtocol: AnyObject {
    func setArtView(for cell: OverviewViewCell, with art: Art, thumbnail: UIImage)
    
    func willLoadInitialData()
    func didLoadInitialData(dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>)
    func failedLoadInitialData(with error: Error)

    func display(dataSourceSnapshot: NSDiffableDataSourceSnapshot<String, ArtPage>) async
    
    func showLoadingActivityView()
    func removeLoadingActivityView()
}
