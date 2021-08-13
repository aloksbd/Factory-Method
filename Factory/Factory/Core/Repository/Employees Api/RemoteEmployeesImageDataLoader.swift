//
//  RemoteEmployeesImageDataLoader.swift
//  Factory
//
//  Created by alok subedi on 13/08/2021.
//

import Foundation

protocol EmployeeImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void)
}

final class RemoteEmployeesImageDataLoader: EmployeeImageDataLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    func loadImageData(from url: URL, completion: @escaping (EmployeeImageDataLoader.Result) -> Void){
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result{
            case .failure:
                completion(.failure(Error.connectivity))
            case let .success((data, response)):
                if response.statusCode == 200 && !data.isEmpty {
                    completion(.success(data))
                } else {
                    completion(.failure(Error.invalidData))
                }
            }
        }
    }
}
