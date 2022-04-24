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
        var alerts: [String] = []
        
        
        print("newRecipe.name")
        print(newRecipe.name)
        print(newRecipe.group)
        print(newRecipe.ingredients)
        print(newRecipe.ingridNormalIndex)
        print(newRecipe.ingridIndex)
        
        print(newRecipe.group)
        print(newRecipe.steps)
        print(newRecipe.ingridIndex)
        
        
        guard let name = newRecipe.name,
              let group = newRecipe.group,
              let ingredients = newRecipe.ingredients,
              let ingridNormalIndex = newRecipe.ingridNormalIndex,
              let ingridIndex = newRecipe.ingridIndex,
              let steps = newRecipe.steps,
              !(newRecipe.name?.isEmpty ?? true),
              !(newRecipe.group?.isEmpty ?? true),
              !(newRecipe.ingredients?.isEmpty ?? true),
              !(newRecipe.steps?.isEmpty ?? true)
        else {
            if newRecipe.name?.isEmpty ?? false { alerts.append("название") }
            if newRecipe.group?.isEmpty ?? false { alerts.append("категорию") }
            if newRecipe.ingredients?.isEmpty ?? false { alerts.append("ингредиенты") }
            if newRecipe.steps?.isEmpty ?? false { alerts.append("шаги готовки") }
            
            var alertText = ""
            for (index, alert) in alerts.enumerated() {
                if index == alerts.count-1 {
                    alertText += alert + "."
                } else {
                    alertText += alert + ", "
                }
            }
            self.popupAlert(title: alertText)
            return
        }
        
        lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)
        let recipe = NSManagedObject(entity: entity!, insertInto: context) as! Recipe
        
        
        
        recipe.name = name
        recipe.group = group
        
        recipe.ingredients = ingredients
        recipe.ingridIndex = ingridIndex
        recipe.ingridNormalIndex = ingridNormalIndex
        recipe.ingridCount = Int16(ingridNormalIndex.count)
        recipe.ingridMatch = 0
        recipe.ingridMatchCount = 0

        recipe.steps = steps
        
        
        if let difficulty = difficultySC.titleForSegment(at: difficultySC.selectedSegmentIndex) {
            switch difficulty {
            case "Просто":
                recipe.difficulty = "просто"
            case "Средняя":
                recipe.difficulty = "средняя"
            case "Сложная":
                recipe.difficulty = "сложно"
            default:
                recipe.difficulty = "просто"
            }
        }

        recipe.img = newRecipe.img
        recipe.isMine = true
        recipe.isFavourite = false
        
        
        
        do {
            try context.save()
        } catch let error as NSError {
            print("no save: \(error)")
        }
        
        showToast(message: "Рецепт добавлен!", font: .systemFont(ofSize: 12.0))
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
            newRecipe.img = image.pngData()
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
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: 20, y: Int(self.view.frame.size.height) - 135, width: Int(self.view.frame.size.width) - 40, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension AddNewRecipeTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        self.recipeNameTF.resignFirstResponder()
        
        self.newRecipe.name = self.recipeNameTF.text
        
        return true
    }
}

extension AddNewRecipeTableViewController {
    func popupAlert(title: String?) {
        let alert = UIAlertController(title: "Упс!", message: "Вы забыли указать " + (title ?? ""), preferredStyle: .alert)
         
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
         
        self.present(alert, animated: true)
    }
}
