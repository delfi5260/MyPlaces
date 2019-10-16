//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Данил Чирков on 02/10/2019.
//  Copyright © 2019 delfi526. All rights reserved.
//

import RealmSwift
let realm = try! Realm() // Создание экземпляра БД

class StorageManager {
    static func svaeObject(_ place: Place) {
        try! realm.write {
            //Так в Realm  проиходит записть в БД
            realm.add(place)
        }
    }
    static func deleteObject(_ place:Place){
        try! realm.write {
            realm.delete(place)
        }
    }
}
