//
//  DetailView.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

class DetailView: UIView {
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3

        let preferredFont = UIFont.preferredFont(forTextStyle: .footnote)
        let italicTrait = UIFontDescriptor.SymbolicTraits.traitItalic
        let descriptor = preferredFont.fontDescriptor.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.symbolic: italicTrait.rawValue
            ]
        ])

        label.font = UIFont(descriptor: descriptor, size: 0)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()

    init() {
        super.init(frame: .zero)

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .secondarySystemBackground

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),

            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DetailView {
    func apply(viewModel: DetailViewModel) {
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
    }
}
