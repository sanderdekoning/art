//
//  OverviewView.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

class OverviewView: UICollectionView {
    init() {        
        super.init(frame: .zero, collectionViewLayout: .art)
        
        setupViews()
    }
    
    @available(* , unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginRefreshing(wantsRefreshControlVisible: Bool = true) {
        guard let refreshControl, !refreshControl.isRefreshing else {
            return
        }
        
        refreshControl.beginRefreshing()
        
        if wantsRefreshControlVisible {
            scrollRectToVisible(refreshControl.frame, animated: true)
        }
    }
    
    func endRefreshing() {
        guard let refreshControl, refreshControl.isRefreshing else {
            return
        }
        
        refreshControl.endRefreshing()
    }
    
    func setupViews() {
        alwaysBounceVertical = true
        
        refreshControl = UIRefreshControl()
    }
}
