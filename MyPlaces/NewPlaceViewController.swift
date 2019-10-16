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
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    var currentPlace: Place?
    var imageIsChanged = false // Флаг меняет ли юзер изображение если нет то ставим дефолд пикчу
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false // Отключаем кнопку сохранения пока юзер не введё PlaceName
        tableView.tableFooterView = UIView() // Убрать разлиновку пустых строк в низу Table
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged) // Отслеживание редактирование TF
        setupEditScreen()
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
    
    func savePlace() {
        
        var image: UIImage?
        if imageIsChanged { // Или пользователь выбрал пикчу или ставим дефолд
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "MapLogo")
        }
        
        let imageData = image?.pngData() // Конвертируем из Data для UIImage
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData)
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
            }
            
        } else { StorageManager.svaeObject(newPlace) } // Добавляем в БД
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    private func setupEditScreen(){
        if currentPlace != nil {
            setupNavigationBar()
            imageIsChanged = true
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill // Масштабируем изображение по содержимому
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            
        }
    }

} // end NPVC

// MARK: Text field delegate

extension NewPlaceViewController: UITextFieldDelegate, UINavigationControllerDelegate{
    // Скрываю клавиатуру по нажатию Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged(){
        // Метод отслеживает пустое ли значение TF. При пустом значении кнопка сохранения отключается
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    
} // end TF delegate

// MARK: Work with image

extension NewPlaceViewController : UIImagePickerControllerDelegate{
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController() // Экзепляр
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // Позволяем масштабировать изображение
            imagePicker.sourceType = source
            present(imagePicker, animated: true) // Вызов
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
    
} // end IPC delegate
