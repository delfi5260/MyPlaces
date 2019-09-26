//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by delfi526 on 26/09/2019.
//  Copyright © 2019 delfi526. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() // Убрать разлиновку пустых строк в низу Table
    }

//MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
    }
    

}
// MARK: Text field delegate

extension NewPlaceViewController: UITextFieldDelegate{
    // Скрываю клавиатуру по нажатию Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
