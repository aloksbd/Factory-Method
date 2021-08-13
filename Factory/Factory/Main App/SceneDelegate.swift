//
//  SceneDelegate.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let navController = UINavigationController()
        
        coordinator = MainCoordinator(navigationController: navController)
    
        coordinator?.start()
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        window?.makeKeyAndVisible()
    }
    
}
