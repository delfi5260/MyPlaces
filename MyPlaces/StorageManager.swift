//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Данил Чирков on 02/10/2019.
//  Copyright © 2019 delfi526. All rights reserved.
//

import RealmSwift
let realm = try! Realm()

class StorageManager {
    
    static func svaeObject(_ place: Place) {
        
        try! realm.write {
            realm.add(place)
        }
    }
}
