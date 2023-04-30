//
//  OverviewViewHeader.swift
//  Art
//
//  Created by Sander de Koning on 23/04/2023.
//

import UIKit

class OverviewViewHeader: UICollectionReusableView {
    var label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(withTitle title: String?) {
        label.text = title
    }
}

private extension OverviewViewHeader {
    func setupViews() {
        backgroundColor = .tertiarySystemBackground

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: 8)
        ])
    }
}
