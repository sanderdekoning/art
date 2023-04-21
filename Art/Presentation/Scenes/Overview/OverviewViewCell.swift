//
//  OverviewViewCell.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import UIKit

class OverviewViewCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var setupTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with art: Art) {
        setupTask = Task {
            do {
                try await setImage(for: art)
            } catch is CancellationError, URLError.cancelled {
                reset()
            } catch ImageWorkerError.unexpectedData {
                // TODO: handle unexpected image data error
                imageView.backgroundColor = .orange
            } catch {
                // TODO: handle image task error, consider retrying
                imageView.backgroundColor = .red
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupTask?.cancel()
        
        reset()
    }
}

private extension OverviewViewCell {
    func setImage(for art: Art) async throws {
        let image = try await ImageWorker().image(
            from: art.webImage.url,
            thumbnailSize: contentView.bounds.size,
            prefersThumbnail: true
        )
        
        // Explicitly check cancellation
        try Task.checkCancellation()
        
        let preparedImage = await image.byPreparingForDisplay()
        imageView.image = preparedImage
        imageView.backgroundColor = nil
    }
    
    func reset() {
        imageView.backgroundColor = nil
        imageView.image = nil
    }
}

extension OverviewViewCell {
    func setupViews() {
        addImageView()
    }
    
    func addImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
