//
//  DetailPresenterProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import UIKit

protocol DetailPresenterProtocol {
    func didLoadArt(art: Art, image: UIImage) async
    func failedLoadArt(with error: Error)
}
