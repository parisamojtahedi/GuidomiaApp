//
//  CoreDataHandler.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-24.
//

import UIKit
import RealmSwift


protocol DataStoreCompatible {
    func retrieveItemsFromRealm() -> Results<RealmCarItem>
    func saveInRealm(using items: [RealmCarItem])
}
class DataStoreHandler: DataStoreCompatible {
    private let realm = try! Realm()
    
    func retrieveItemsFromRealm() -> Results<RealmCarItem>  {
        realm.objects(RealmCarItem.self)
    }
    
    func saveInRealm(using items: [RealmCarItem]) {
        do {
            let realm = try Realm()
            realm.add(items)
            try! realm.commitWrite()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
