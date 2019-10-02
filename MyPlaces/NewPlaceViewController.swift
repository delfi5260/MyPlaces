//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by delfi526 on 26/09/2019.
//  Copyright © 2019 delfi526. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!

    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var typeName: UITextField!
    
    
    var imageIsChanged = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        tableView.tableFooterView = UIView() // Убрать разлиновку пустых строк в низу Table
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        
    }

//MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image") // вставляем значение по ключу
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image") // вставляем значение по ключу
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    func saveNewPlace() {
        
        var image: UIImage?
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!, location: locationName.text, type: typeName.text, imageData: imageData)
        
        StorageManager.svaeObject(newPlace)
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    

}
// MARK: Text field delegate

extension NewPlaceViewController: UITextFieldDelegate, UINavigationControllerDelegate{
    // Скрываю клавиатуру по нажатию Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged(){
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    
}

// MARK: Work with image
extension NewPlaceViewController : UIImagePickerControllerDelegate{
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController() // Экзепляр
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // Позволяем масштабировать изображение
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill // масштабирование изображение по содержимому UIImage
        placeImage.clipsToBounds = true // Обрезка по границе UIImage
        imageIsChanged = true // изменить перед выбором
        dismiss(animated: true) // закрываем пикер
        
    }
    
}
