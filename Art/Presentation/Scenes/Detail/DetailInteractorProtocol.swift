//
//  DetailInteractorProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import Foundation

protocol DetailInteractorProtocol {
    var art: Art { get }

    func loadArt() async throws
}
