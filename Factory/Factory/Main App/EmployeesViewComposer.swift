//
//  EmployeesViewComposer.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit
import CoreData

final class EmployeesViewComposer {
    static func createEmployeesViewController(setting: Settings, repository: EmployeesRepository, imageLoader: EmployeeImageDataLoader) -> EmployeesViewController {
        let view = EmployeesViewFactory().createEmployeesView(for: setting)
        let loader = EmployeeRepositoryPresenterAdapter(repository: repository)
        let employeesViewController = EmployeesViewController(loader: loader, employeesView: view)
        let presenter = EmployeesPresenter(employeesView: EmployeesViewAdapter(view: view as! EmployeesListView, imageLoader: imageLoader), loadingView: employeesViewController, errorView: employeesViewController)
        loader.presenter = presenter
        return employeesViewController
    }
    
    func createRepository() -> EmployeesRepository {
        let repository = Repository()
        let localRepository = LocalEmployeesRepository(store: store, currentDate: Date.init)
        let remoteRepository = EmployeesRepositoryCacheDecorator(decoratee: repository, cache: localRepository)
        
        return RemoteWithLocalRepository(remote: remoteRepository, local: localRepository)
    }
    
    func createImageLoader() -> EmployeeImageDataLoader {
        let loader =  DummyImageLoader()
        let localLoader = LocalEmployeesImageDataLoader(store: store)
        let remoteLoader = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: localLoader)
        
        return LocalWithRemoteEmployeeImageDataLoader(primary: localLoader, fallback: remoteLoader)
    }
    
    private var store: EmployeesStore & EmployeesImageDataStore {
        return try! CoreDataEmployeesStore(storeURL: NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("employees-store.sqlite"))
    }
}

final class DummyImageLoader: EmployeeImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (EmployeeImageDataLoader.Result) -> Void) {
        completion(.success(makeImage(withColor: .red).jpegData(compressionQuality: 1)!))
    }
    
    func makeImage(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

final private class Repository: EmployeesRepository {
    func load(completion: @escaping (EmployeesRepository.Result) -> Void) {
        completion(
            .success([
                Employee(id: UUID(), name: "Employee 1", designation: "designation 1", salary: 1, url: URL(string: "https://url1.com")!),
                Employee(id: UUID(), name: "Employee 2", designation: "designation 2", salary: 2, url: URL(string: "https://url2.com")!),
                Employee(id: UUID(), name: "Employee 3", designation: "designation 3", salary: 3, url: URL(string: "https://url3.com")!)
            ])
        )
    }
}

class RemoteWithLocalRepository: EmployeesRepository {
    private let remote: EmployeesRepository
    private let local: EmployeesRepository

    init(remote: EmployeesRepository, local: EmployeesRepository) {
        self.remote = remote
        self.local = local
    }
    
    func load(completion: @escaping (EmployeesRepository.Result) -> Void) {
        remote.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self?.local.load(completion: completion)
            }
        }
    }
}

final class EmployeesRepositoryCacheDecorator: EmployeesRepository {
    private let decoratee: EmployeesRepository
    private let cache: EmployeesCache
    
    init(decoratee: EmployeesRepository, cache: EmployeesCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (EmployeesRepository.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { employees in
                self?.cache.save(employees) { _ in }
                return employees
            })
        }
    }
}

final class LocalWithRemoteEmployeeImageDataLoader: EmployeeImageDataLoader {
    private let local: EmployeeImageDataLoader
    private let remote: EmployeeImageDataLoader

    init(primary: EmployeeImageDataLoader, fallback: EmployeeImageDataLoader) {
        self.local = primary
        self.remote = fallback
    }

    func loadImageData(from url: URL, completion: @escaping (EmployeeImageDataLoader.Result) -> Void) {
        local.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self?.remote.loadImageData(from: url, completion: completion)
            }

        }
    }
}

final class FeedImageDataLoaderCacheDecorator: EmployeeImageDataLoader {
    private let decoratee: EmployeeImageDataLoader
    private let cache: EmployeesImageDataCache

    init(decoratee: EmployeeImageDataLoader, cache: EmployeesImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadImageData(from url: URL, completion: @escaping (EmployeeImageDataLoader.Result) -> Void) {
        decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.cache.save(data, for: url) { _ in }
                return data
            })
        }
    }
}

final class EmployeesViewAdapter: EmployeesView {
    private var view: EmployeesListView
    private let imageLoader: EmployeeImageDataLoader
    
    init(view: EmployeesLayoutView, imageLoader: EmployeeImageDataLoader) {
        self.view = view as! EmployeesListView
        self.imageLoader = imageLoader
    }
    
    func displayEmployees(_ viewModel: EmployeesViewModel) {
        view.display(viewModel.employees.map { employee in
            let adapter = EmployeesImageDataLoaderPresentaterAdapter(model: employee, imageLoader: imageLoader)
            let view = EmployeesListCellController(loader: adapter, employee: employee)
            
            adapter.presenter = EmployeeImagePresenter(view: view)
            
            return view
        })
    }
    
    func getView() -> UIView {
        return view.getView()
    }
}

final class EmployeesImageDataLoaderPresentaterAdapter: ImageLoader {
    private let model: PresentableEmployee
    private let imageLoader: EmployeeImageDataLoader
    
    var presenter: EmployeeImagePresenter?
    
    init(model: PresentableEmployee, imageLoader: EmployeeImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func loadImage() {
        presenter?.didStartLoadingImageData()

        imageLoader.loadImageData(from: model.url) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImageData(with: data)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingImageData(with: error)
            }
        }
    }
}

final class EmployeeRepositoryPresenterAdapter: EmployeesLoader {
    private let repository: EmployeesRepository
    var presenter: EmployeesPresenter?
    
    init(repository: EmployeesRepository) {
        self.repository = repository
    }
    
    func load() {
        presenter?.didStartLoadingEmployees()
        
        repository.load { [weak self] result in
            switch result {
            case let .success(employees):
                self?.presenter?.didFinishLoadingEmployees(with: employees)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingEmployees(with: error)
            }
        }
    }
}
