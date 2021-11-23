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
}

protocol CarListInteractor {
    var presenter: CarListPresenter? { get set }
    func fetchItems()
    func getItem(for indexPath: IndexPath) -> CellConfigurator
    func getNumberOfItems() -> Int
}
class CarListInteractorImp: CarListInteractor {
    private let serviceProvider: ServiceProvider
    private var carList: [CellConfigurator] = []
    weak var presenter: CarListPresenter?

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }
    
    func fetchItems() {
        carList.append(ImageCellConfigurator(item: ImageTableViewCellModel(image: UIImage(named: "Tacoma")!, topLabelText: "Guidomia")))
        serviceProvider.fetchItems { [weak self] result in
            switch result {
            case .success(let carList):
                carList.forEach({ self?.makeCarItem(using: $0)})
                self?.updateUI()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func makeCarItem(using item: CarItem) {
        let item = CarCellConfigurator(item: CarTableViewCellModel(image: UIImage(named: "\(item.model)") ?? UIImage(),
                                                                   name: item.model,
                                                                   price: "\(item.marketPrice)",
                                                                   numericStar: item.rating,
                                                                   prosList: item.prosList,
                                                                   consList: item.consList))
        carList.append(item)
    }
    
    func updateUI() {
        presenter?.updateUI()
    }
    
    func getItem(for indexPath: IndexPath) -> CellConfigurator {
        return carList[indexPath.row]
    }
    
    func getNumberOfItems() -> Int {
        return carList.count
    }
    
}
