//
//  CarListPresenter.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-22.
//

import Foundation
import UIKit

protocol CarListPresenter: AnyObject {
    var controller: CarListView? { get set }
    var interactor: CarListInteractor! { get set }
    var router: CarListRouter? { get set }
    
    func onViewDidLoad()
    func getItem(for indexPath: IndexPath) -> CellConfigurator
    func getNumberOfItems() -> Int
    func updateUI()
}
class CarListPresenterImp: CarListPresenter {
    weak var controller: CarListView?
    var interactor: CarListInteractor!
    var router: CarListRouter?
    
    func onViewDidLoad() {
        interactor.fetchItems()
    }
    
    func getItem(for indexPath: IndexPath) -> CellConfigurator {
        interactor.getItem(for: indexPath)
    }
    
    func updateUI() {
        controller?.updateUI()
    }
    
    func getNumberOfItems() -> Int {
        return interactor.getNumberOfItems()
    }
}
