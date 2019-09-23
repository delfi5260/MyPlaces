//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by delfi526 on 18/09/2019.
//  Copyright © 2019 delfi526. All rights reserved.
//

import Foundation
struct Place {
    
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let placesName = ["Burger King","Lincoln","McDonalds","Terma Loundg","Silver Panda","Морковь","Июнь"]
       
       static func getPlaces() -> [Place] {
           
           var places = [Place]()
           
           for place in placesName {
               places.append(Place(name: place, location: "Москва", type: "Ресторан", image: place))
           }
           return places
       }
    
}
