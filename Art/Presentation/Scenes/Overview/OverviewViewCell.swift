//
//  OverviewViewCell.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import UIKit

class OverviewViewCell: UICollectionViewCell {
    var setupTask: Task<Void, Never>?
    var imageWorker: ImageWorkerProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with art: Art, worker: any ImageWorkerProtocol) {
        imageWorker = worker
        
        setupTask = Task {
            do {
                try await setArtView(for: art, worker: worker)
            } catch is CancellationError, URLError.cancelled {
                reset()
            } catch ImageWorkerError.unexpectedData {
                // TODO: handle unexpected image data error
            } catch {
                // TODO: handle image task error, consider retrying
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupTask?.cancel()
        setupTask = nil
        
        reset()
    }
}

private extension OverviewViewCell {
    func setArtView(for art: Art, worker: any ImageWorkerProtocol) async throws {
        backgroundView = OverviewViewCellLoadingView()
        
        let image = try await worker.image(
            from: art.webImage.url,
            thumbnailSize: contentView.bounds.size,
            prefersThumbnail: true
        )
        
        // Explicitly check cancellation
        try Task.checkCancellation()

        // TODO: present the prepared image in the content view with its title
        let preparedImage = await image.byPreparingForDisplay()
        
        backgroundView = nil
        
        let artView = OverviewViewCellArtView(image: preparedImage, title: art.title)
        artView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(artView)
        
        NSLayoutConstraint.activate([
            artView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            artView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            artView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
    }
    
    func reset() {
        backgroundView = nil
        
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
}
