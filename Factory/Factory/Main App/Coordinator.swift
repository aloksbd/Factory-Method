//
//  Coordinator.swift
//  Factory
//
//  Created by alok subedi on 13/08/2021.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let composer = EmployeesViewComposer()
        let vc = EmployeesViewComposer.createEmployeesViewController(setting: .list, repository: composer.createRepository(), imageLoader: composer.createImageLoader())
        navigationController.pushViewController(vc, animated: false)
    }
}
