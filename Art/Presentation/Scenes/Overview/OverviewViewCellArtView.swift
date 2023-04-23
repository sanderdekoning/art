//
//  OverviewViewCellArtView.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

class OverviewViewCellArtView: UIView {
    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
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
    
    init(image: UIImage?, title: String) {
        super.init(frame: .zero)
        
        setupViews(image: image, title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(image: UIImage?, title: String) {
        backgroundColor = .secondarySystemBackground
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        addSubview(imageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
}
