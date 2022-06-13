//
//  AnimalService.swift
//  TCADemo
//
//  Created by Michael Bernat on 13.06.2022.
//

import Foundation
import Combine

//MARK: - Animal
struct Animal: Equatable, Decodable, Identifiable {
    let name: String
    let id: Int
}

//MARK: - AnimalError
enum AnimalServiceError: Error {
    case universalError
}

//MARK: - AnimalServiceProtocol
protocol AnimalServiceProtocol {
    func getAnimals(count: Int) -> AnyPublisher<[Animal], AnimalServiceError>
}

//MARK: - AnimalService
class AnimalService: AnimalServiceProtocol {
    
    func getAnimals(count: Int) -> AnyPublisher<[Animal], AnimalServiceError> {
        guard let url = URL(string: "https://zoo-animal-api.herokuapp.com/animals/rand/\(count)") else {
            return Fail(error: .universalError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Animal].self, decoder: JSONDecoder())
            .mapError { _ in AnimalServiceError.universalError }
            .eraseToAnyPublisher()
    }
    
}

//MARK: - AnimalServicePreview
class AnimalServicePreview: AnimalServiceProtocol {
    
    func getAnimals(count: Int) -> AnyPublisher<[Animal], AnimalServiceError> {
        var animals: [Animal] = []
        for i in 1...count {
            animals.append(Animal(name: "Animal #\(i)", id: i))
        }
        return Just(animals)
            .setFailureType(to: AnimalServiceError.self)
            .eraseToAnyPublisher()
    }
    
}
