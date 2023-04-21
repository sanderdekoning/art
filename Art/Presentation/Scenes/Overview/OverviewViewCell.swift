//
//  OverviewViewCell.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import UIKit

class OverviewViewCell: UICollectionViewCell {
    var setupTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with art: Art) {
        setupTask = Task {
            do {
                try await setBackgroundImage(for: art)
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
        
        reset()
    }
}

private extension OverviewViewCell {
    func imageView(image: UIImage) -> UIImageView {
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }
    
    func setBackgroundImage(for art: Art) async throws {
        backgroundView = OverviewViewCellLoadingView()

        let image = try await ImageWorker().image(
            from: art.webImage.url,
            thumbnailSize: contentView.bounds.size,
            prefersThumbnail: true
        )
        
        // Explicitly check cancellation
        try Task.checkCancellation()

        // TODO: present the prepared image in the content view with its title
        let preparedImage = await image.byPreparingForDisplay()
        backgroundView = imageView(image: preparedImage ?? image)
    }
    
    func reset() {
        backgroundView = nil
    }
}

class OverviewViewCellLoadingView: UIView {
    var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = false
        activity.style = .medium
        return activity
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
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
}
