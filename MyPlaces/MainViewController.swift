//
//  MainViewController.swift
//  MyPlaces
//
//  Created by delfi526 on 09/09/2019.
//  Copyright © 2019 delfi526. All rights reserved.
//

import UIKit
import RealmSwift
//1
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var places: Results<Place>! //PlaceModel.swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self) // Place.self потому что мы указываем тип запрашиваемых данных а не саму модель
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count // Если база пуста то 0 иначе посчёт кол-во
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!) // Преобразовыем тип Data в изображение. Принудительно извликаем т.к. в любом случае изображение либо юзера либо дефолд
        cell.imageOfPlace.clipsToBounds = true
        cell.imageOfPlace.contentMode = .scaleToFill
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let place = places[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return} // Получаем индекс выбранного обекта
            let place = places[indexPath.row]
            guard let newPlaceVC = segue.destination as? NewPlaceViewController else {return}
            newPlaceVC.currentPlace = place
            
        }
    }
    
    // Выход из контроллера создания
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) { // При нажатии кнопки Save
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return} // Юзаем segue.source  так как мы передаем данные на котроллер к кторому возвращаемся
        newPlaceVC.savePlace()
        
        tableView.reloadData()
    }
    
} // end class
