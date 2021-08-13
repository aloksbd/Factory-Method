//
//  EmployeesItemsMapper.swift
//  Factory
//
//  Created by alok subedi on 13/08/2021.
//

import Foundation

final class EmployeesMapper {
    private struct Root: Decodable {
        let employees: [RemoteEmployees]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteEmployees] {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteEmployeesRepository.Error.invalidData
        }

        return root.employees
    }
}

struct RemoteEmployees: Decodable {
    let id: UUID
    let name: String
    let designation: String
    let salary: Int
    let url: URL
}
