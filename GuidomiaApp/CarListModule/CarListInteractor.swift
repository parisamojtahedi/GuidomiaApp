//
//  CarListViewModel.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-22.
//

import Foundation
import UIKit
import RealmSwift
import Realm

struct CarItem: Decodable {
    var model: String = ""
    var marketPrice: Double = 0.0
    var rating: Int = 0
    var prosList: [String] = []
    var consList: [String] = []
    var make: String = ""
}

class RealmCarItem: RealmSwiftObject {
    @objc dynamic var model: String = ""
    @objc dynamic var marketPrice: Double = 0.0
    @objc dynamic var rating: Int = 0
    var prosList = List<String>()
    var consList = List<String>()
    @objc dynamic var make: String = ""
}


protocol CarListInteractor {
    var presenter: CarListPresenter? { get set }
    func fetchItems()
}
class CarListInteractorImp: CarListInteractor {
    private let serviceProvider: ServiceProvider
    private let dataStoreHandler: DataStoreCompatible
    
    weak var presenter: CarListPresenter?
    private var carItems: [CarItem] = []
    private var filteredItems: [TableViewSectionTypes] = []
    private var sections: [TableViewSectionTypes] = []
    private let realm = try! Realm()
    
    init(serviceProvider: ServiceProvider,
         dataStoreHandler: DataStoreCompatible) {
        self.serviceProvider = serviceProvider
        self.dataStoreHandler = dataStoreHandler
        
        let reloadClosure: ((FilterQuery) -> Void) = { [weak self] query in
            self?.filterItems(using: query.searchText, filter: query.filter)
        }
        
        sections.append(contentsOf: [.image,
                                     .filter(model: FilterTableViewCellModel(reloadClosure: reloadClosure))])
    }
    
    func fetchItems() {
        if !dataStoreHandler.retrieveItemsFromRealm().isEmpty {
            let objects = realm.objects(RealmCarItem.self)
            var carList: [CarItem] = []

            for obj in objects {
                var item = CarItem()
                item.model = obj.model
                item.make = obj.make
                item.marketPrice = obj.marketPrice
                item.rating = obj.rating
                item.prosList = Array(obj.prosList)
                item.consList = Array(obj.consList)
                carList.append(item)
            }
            self.carItems = carList
            sections.append(.car(model: carList.map({ self.makeCarItem(using: $0)})))
            self.updateUI()
            return
            
        }
        serviceProvider.fetchItems { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let carList):
                self.carItems = carList
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    var realmList: [RealmCarItem] = []
                    
                    for item in carList {
                        let proList = List<String>()
                        let consList = List<String>()

                        let realmItem = RealmCarItem()
                        realmItem.model = item.model
                        realmItem.make = item.make
                        realmItem.marketPrice = item.marketPrice
                        realmItem.rating = item.rating
                        proList.append(objectsIn: item.prosList)
                        consList.append(objectsIn: item.consList)
                        realmItem.prosList = proList
                        realmItem.consList = consList
                        realmList.append(realmItem)
                    }
                    dataStoreHandler.saveInRealm(using: realmList)
                } catch {
                    print(error.localizedDescription)
                }
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
                                     prosList: Array(item.prosList),
                                     consList: Array(item.consList))
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
