//
//  ServiceProvider.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-22.
//

import Foundation

protocol ServiceProvider {
    func fetchItems(completion: (Result<[CarItem], Error>) -> Void)
}
class ServiceProviderImp: ServiceProvider {
    func fetchItems(completion: (Result<[CarItem], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "car_list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([CarItem].self, from: data)
                completion(.success(jsonData))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    
}
