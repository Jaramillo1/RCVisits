/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation
import SwiftUI

class VisitStore: ObservableObject {
    @Published var visits: [DailyVisit] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("visits.data")
    }
    
    static func load() async throws -> [DailyVisit] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[DailyVisit], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let dailyVisits = try JSONDecoder().decode([DailyVisit].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(dailyVisits))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(visits: [DailyVisit]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(visits: visits) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let visitsSaved):
                    continuation.resume(returning: visitsSaved)
                }
            }
        }
    }
    
    static func save(visits: [DailyVisit], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(visits)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(visits.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
