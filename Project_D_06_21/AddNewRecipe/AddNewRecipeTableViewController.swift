//
//  AddNewRecipeTableViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 14.04.2022.
//

import UIKit
import CoreData

class NewRecipe {
    var difficulty: String?
    var group: String?
    var img: Data?
    var ingredients: String?
    var ingridCount: Int16
    var ingridIndex: [Int]?
    var ingridMatch: Double
    var ingridNormalIndex: [Int]?
    var isFavourite: Bool
    var isMine: Bool
    var name: String?
    var steps: String?
    
    init() {
        self.difficulty = ""
        self.group = ""
        self.img = (UIImage(named: "noPhoto.jpg")!).pngData()
        self.ingredients = ""
        self.ingridCount = 0
        self.ingridIndex = [] as [Int]
        self.ingridMatch = 0
        self.ingridNormalIndex = [] as [Int]
        self.isFavourite = false
        self.isMine = true
        self.name = ""
        self.steps = ""
    }
}

class AddNewRecipeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var newRecipe: NewRecipe = NewRecipe()
    var delegate: FilterRecipeDelegate?
    
    @IBOutlet weak var newRecipeImg: UIImageView!
    @IBOutlet weak var recipeNameTF: UITextField!
    @IBOutlet weak var difficultySC: UISegmentedControl!
    
    @IBAction func addNewRecipeButtonTapped(_ sender: Any) {
        /*
        lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)
        let recipe = NSManagedObject(entity: entity!, insertInto: context) as! Recipe
        recipe.name = newRecipe.name
        recipe.difficulty = newRecipe.difficulty
        recipe.group = newRecipe.group
        recipe.ingredients = newRecipe.ingredients
        recipe.steps = newRecipe.steps

        recipe.img = newRecipe.img
        
        let ingrids = newRecipe.ingredients?.components(separatedBy: ";")
        recipe.ingridCount = Int16(ingrids.count)
        recipe.ingridMatch = 0
        recipe.ingridMatchCount = 0
        recipe.isMine = true

        
        // ingridIndex
        var ingridIndex: Array<Int> = []

        for ingrid in ingrids {
            ingridIndex.append(Int(allIngrids.filter{ $0.name!.contains(ingrid) }[0].index))
        }
        recipe.ingridIndex = ingridIndex as [Int]
 
        
        
        // ingridNormalIndex
        var ingridNormalIndex: Array<Int> = []
        for ingrid in ingridIndex {
            guard let newIndex = Optional(Int(allIngridients.filter{ $0.index!.components(separatedBy: ";").contains(String(ingrid)) }[0].curIndex)) else { return }
            ingridNormalIndex.append(newIndex)
        }
        
        recipe.ingridNormalIndex = ingridNormalIndex as [Int]
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(newRecipe.name ?? "").isEmpty {
            self.recipeNameTF.text = newRecipe.name
        }
        
        recipeNameTF.returnKeyType = .done
        recipeNameTF.autocapitalizationType = .words
        recipeNameTF.autocorrectionType = .no
        recipeNameTF.delegate = self
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
//        if indexPath.row == 4 {
//            
//        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addIngridsToRecipe" {
            let dvc = segue.destination as! AddNewIngridsToRecipeTableViewController
            
            dvc.newRecipe = newRecipe
        }
        if segue.identifier == "addGroupToRecipe" {
            let dvc = segue.destination as! AddGroupToRecipeTableViewController
            
            dvc.newRecipe = newRecipe
            dvc.delegate = delegate
        }
        if segue.identifier == "addSteps" {
            let dvc = segue.destination as! AddStepsToRecipeViewController
            
            dvc.newRecipe = newRecipe
            
        }
    }
}

extension AddNewRecipeTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        self.recipeNameTF.resignFirstResponder()
        
        self.newRecipe.name = self.recipeNameTF.text
        
        return true
    }
}

