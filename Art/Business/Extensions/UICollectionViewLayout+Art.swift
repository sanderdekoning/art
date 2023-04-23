//
//  UICollectionViewLayout+Art.swift
//  Art
//
//  Created by Sander de Koning on 21/04/2023.
//

import UIKit

extension UICollectionViewLayout {
    static var art: UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            ),
            repeatingSubitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(4)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.pinToVisibleBounds = false
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 4

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 200

        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        return layout
    }
}
