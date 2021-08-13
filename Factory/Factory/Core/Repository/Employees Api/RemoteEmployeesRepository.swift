//
//  RemoteEmployeesRepository.swift
//  Factory
//
//  Created by alok subedi on 13/08/2021.
//

import Foundation

final class RemoteEmployeesRepository: EmployeesRepository {
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    typealias Result = EmployeesRepository.Result
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteEmployeesRepository.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try EmployeesMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteEmployees {
    func toModels() -> [Employee] {
        return map { Employee(id: $0.id, name: $0.name, designation: $0.designation, salary: $0.salary, url: $0.url)}
    }
}
