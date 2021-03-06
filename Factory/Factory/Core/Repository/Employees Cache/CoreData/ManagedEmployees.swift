//
//  ManagedEmployees.swift
//  Factory
//
//  Created by alok subedi on 13/08/2021.
//

import CoreData

@objc(ManagedEmployees)
class ManagedEmployees: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var designation: String
    @NSManaged var salary: Int64
    @NSManaged var cache: ManagedCache
    @NSManaged var url: URL
    @NSManaged var data: Data
}

extension ManagedEmployees {
    static func employees(from employees: [Employee], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: employees.map { local in
            let managed = ManagedEmployees(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.designation = local.designation
            managed.salary = Int64(local.salary)
            managed.url = local.url
            return managed
        })
    }
    
    var local: Employee {
        return Employee(id: id, name: name, designation: designation, salary: Int(salary), url: url)
    }
    
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedEmployees? {
        let request = NSFetchRequest<ManagedEmployees>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedEmployees.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
