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
    func updateUI(using sections: [TableViewSectionTypes])
    func updateCarSection(using sections: [TableViewSectionTypes])
}
class CarListPresenterImp: CarListPresenter {
    weak var controller: CarListView?
    var interactor: CarListInteractor!
    var router: CarListRouter?
    
    func onViewDidLoad() {
        interactor.fetchItems()
    }
    
    func updateUI(using sections: [TableViewSectionTypes]) {
        controller?.updateUI(using: sections)
    }
    
    func updateCarSection(using sections: [TableViewSectionTypes]) {
        controller?.updateCarSection(using: sections)
    }
}
