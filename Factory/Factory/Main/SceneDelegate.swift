//
//  SceneDelegate.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
    
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController(
            rootViewController: EmployeesViewComposer.createEmployeesViewController(setting: .list, repository: Repository()))
        
        window?.makeKeyAndVisible()
    }
}

final private class Repository: EmployeesRepository {
    func load(completion: @escaping ([PresentableEmployee]) -> Void) {
        completion([
            PresentableEmployee(name: "Employee 1", designation: "designation 1", salary: "1"),
            PresentableEmployee(name: "Employee 2", designation: "designation 2", salary: "2"),
            PresentableEmployee(name: "Employee 3", designation: "designation 3", salary: "3")
        ])
    }
}
