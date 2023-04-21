//
//  SceneDelegate.swift
//  Art
//
//  Created by Sander de Koning on 19/04/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
                
        let overviewViewController = OverviewViewController()
        let navigationController = UINavigationController(
            rootViewController: overviewViewController
        )
        OverviewConfigurator.configureScene(viewController: overviewViewController)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
