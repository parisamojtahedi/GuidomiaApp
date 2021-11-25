//
//  CarListRouter.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-22.
//

import Foundation
import UIKit

protocol CarListRouter {
    static func buildModule(serviceProvider: ServiceProvider,
                            view: CarListView)}
class CarListWireframe: CarListRouter {
    static func buildModule(serviceProvider: ServiceProvider,
                            view: CarListView) {
        let presenter: CarListPresenter = CarListPresenterImp()
        var interactor:  CarListInteractor = CarListInteractorImp(serviceProvider: serviceProvider,
                                                                  dataStoreHandler: DataStoreHandler())
        let router = CarListWireframe()
        
        view.presenter = presenter
        presenter.controller = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
