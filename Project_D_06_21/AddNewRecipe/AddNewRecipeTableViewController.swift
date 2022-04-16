//
//  AddNewRecipeTableViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 14.04.2022.
//

import UIKit

class AddNewRecipeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var newRecipe: Recipe = Recipe()
    
    @IBOutlet weak var newRecipeImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            newRecipeImg.image = image
        }
        newRecipeImg.contentMode = .scaleAspectFill
        newRecipeImg.clipsToBounds = true
      dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      if indexPath.row == 0 {
        let alertController = UIAlertController(title: "Источник фотографии", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Камера", style: .default, handler: { (action) in
          self.chooseImagePickerAction(source: .camera)
        })
        let photoLibAction = UIAlertAction(title: "Фото", style: .default, handler: { (action) in
          self.chooseImagePickerAction(source: .photoLibrary)
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
      }
      
      tableView.deselectRow(at: indexPath, animated: true)
    }

      
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
      if UIImagePickerController.isSourceTypeAvailable(source) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
      }
    }
}

  
