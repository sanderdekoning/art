//
//  OverviewViewCell.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import UIKit

class OverviewViewCell: UICollectionViewCell {
    private var setupTask: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        setupTask?.cancel()
        setupTask = nil

        reset()
    }
}

extension OverviewViewCell {
    func setup(with task: Task<Void, Never>) {
        setupTask = task

        showLoadingActivityView()
    }

    func showLoadingActivityView() {
        reset()

        backgroundView = OverviewViewCellLoadingView()
    }

    func setArtView(for art: Art, image: UIImage) {
        reset()

        let artView = OverviewViewCellArtView(image: image, title: art.title)
        artView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(artView)

        NSLayoutConstraint.activate([
            artView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            artView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            artView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
    }
}

private extension OverviewViewCell {
    func reset() {
        backgroundView = nil

        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
}
