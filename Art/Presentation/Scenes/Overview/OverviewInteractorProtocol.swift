//
//  OverviewInteractorProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import Foundation

protocol OverviewInteractorProtocol: AnyObject {
    func loadInitialData() async throws
    func refresh() async throws

    func willSetupCell(for artPage: ArtPage) async throws
    func willDisplayLastCell() async throws
    func setup(cell: OverviewViewCell, with art: Art) async throws
}
