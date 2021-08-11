//
//  LoadEmployeesFromCacheUseCaseTests.swift
//  FactoryTests
//
//  Created by alok subedi on 11/08/2021.
//

import XCTest
@testable import Factory

class LoadEmployeesFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotCallStore() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_deliversNoEmployeesOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversCachedEmployeesOnNonExpiredCache() {
        let employees = uniqueEmployees()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusEmployeesCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success(employees), when: {
            store.completeRetrieval(with: employees, timestamp: nonExpiredTimestamp)
        })
    }
    
    func test_load_deliversNoEmployeesOnCacheExpiration() {
        let employees = uniqueEmployees()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusEmployeesCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: employees, timestamp: expirationTimestamp)
        })
    }
    
    func test_load_deliversNoEmployeesOnExpiredCache() {
        let employees = uniqueEmployees()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusEmployeesCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: employees, timestamp: expiredTimestamp)
        })
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnNonExpiredCache() {
        let employees = uniqueEmployees()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusEmployeesCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: employees, timestamp: nonExpiredTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnCacheExpiration() {
        let employees = uniqueEmployees()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusEmployeesCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.load { _ in }
        store.completeRetrieval(with: employees, timestamp: expirationTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnExpiredCache() {
        let employees = uniqueEmployees()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusEmployeesCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.load { _ in }
        store.completeRetrieval(with: employees, timestamp: expiredTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = EmployeesStoreSpy()
        var sut: LocalEmployeesRepository? = LocalEmployeesRepository(store: store, currentDate: Date.init)
        
        var receivedResults = [LocalEmployeesRepository.LoadResult]()
        sut?.load { receivedResults.append($0) }
        
        sut = nil
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalEmployeesRepository, store: EmployeesStoreSpy) {
        let store = EmployeesStoreSpy()
        let sut = LocalEmployeesRepository(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalEmployeesRepository, toCompleteWith expectedResult: LocalEmployeesRepository.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedEmployees), .success(expectedEmployees)):
                XCTAssertEqual(receivedEmployees, expectedEmployees, file: file, line: line)
            
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }

}

extension Date {
    func minusEmployeesCacheMaxAge() -> Date {
        return adding(days: -employeesCacheMaxAgeInDays)
    }
    
    private var employeesCacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
