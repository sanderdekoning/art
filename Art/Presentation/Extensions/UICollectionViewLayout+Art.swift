//
//  UICollectionViewLayout+Art.swift
//  Art
//
//  Created by Sander de Koning on 21/04/2023.
//

import UIKit

extension UICollectionViewLayout {
    private static func group(
        repeatingItem item: NSCollectionLayoutItem
    ) -> NSCollectionLayoutGroup {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1)
        )

        if #available(iOS 16.0, *) {
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                repeatingSubitem: item,
                count: 1
            )
        } else {
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitem: item,
                count: 1
            )
        }
    }

    static var art: UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))

        let group = group(repeatingItem: item)
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
        config.interSectionSpacing = 180

        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        return layout
    }
}
