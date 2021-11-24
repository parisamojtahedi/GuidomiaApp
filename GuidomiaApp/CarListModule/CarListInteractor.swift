//
//  CarListViewModel.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-22.
//

import Foundation
import UIKit

struct CarItem: Decodable {
    let model: String
    let marketPrice: Double
    let rating: Int
    let prosList: [String]
    let consList: [String]
    let make: String
}

protocol CarListInteractor {
    var presenter: CarListPresenter? { get set }
    func fetchItems()
}
class CarListInteractorImp: CarListInteractor {
    private let serviceProvider: ServiceProvider
    weak var presenter: CarListPresenter?
    private var carItems: [CarItem] = []
    private var filteredItems: [TableViewSectionTypes] = []
    private var sections: [TableViewSectionTypes] = []
    
    
    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
        let reloadClosure: ((FilterQuery) -> Void) = { [weak self] query in
            self?.filterItems(using: query.searchText, filter: query.filter)
        }
        
        sections.append(contentsOf: [.image,
                                     .filter(model: FilterTableViewCellModel(reloadClosure: reloadClosure))])
    }
    
    func fetchItems() {
        serviceProvider.fetchItems { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let carList):
                self.carItems = carList
                sections.append(.car(model: carList.map({ self.makeCarItem(using: $0)})))
                self.updateUI()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func makeCarItem(using item: CarItem) -> CarTableViewCellModel {
        return CarTableViewCellModel(image: UIImage(named: "\(item.model)") ?? UIImage(),
                                     name: item.model,
                                     price: "\(item.marketPrice)",
                                     numericStar: item.rating,
                                     prosList: item.prosList,
                                     consList: item.consList)
    }
    
    func updateUI() {
        presenter?.updateUI(using: sections)
    }
    
    private func filterItems(using text: String, filter: SearchfilterType) {
        filteredItems = []

        if text.isEmpty {
            filteredItems.append(.car(model: carItems.map({ self.makeCarItem(using: $0)})))
            updateSections(with: filteredItems)
        } else {
            switch filter {
            case .model:
                filteredItems.append(.car(model: carItems.filter({ $0.model.contains(text)})
                                        .map({ self.makeCarItem(using: $0)})))
                updateSections(with: filteredItems)

            case .make:
                filteredItems.append(.car(model: carItems.filter({ $0.make.contains(text)})
                                        .map({ self.makeCarItem(using: $0)})))
                updateSections(with: filteredItems)
            }
        }
        presenter?.updateCarSection(using: sections)
    }
    
    private func updateSections(with newSections: [TableViewSectionTypes]) {
        for index in 0..<sections.count {
            switch sections[index] {
            case.car:
                sections.remove(at: index)
                sections.append(contentsOf: newSections)
            default:
                break
            }
        }
    }
}

enum SearchfilterType {
    case model
    case make
}
