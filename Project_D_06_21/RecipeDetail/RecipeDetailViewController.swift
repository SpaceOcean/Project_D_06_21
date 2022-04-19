//
//  RecipeDetailViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 17.03.2022.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var recipeItem: Recipe = Recipe()
    let defaultImg: String = "noPhoto"
    var arrayOfIngredients: Array<String> = []
    var arrayOfUserIngridients: Array<Int> = []
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var addToFavouritesButton: UIButton!

    @IBOutlet weak var recipeMatchLabel: UILabel!
    @IBOutlet weak var recipeGroupLabel: UILabel!
    @IBOutlet weak var recipeDifficultyLabel: UILabel!
    @IBOutlet weak var ingridientsTableView: UITableView!
    @IBOutlet weak var ingridientsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var recipeDetailTextView: UITextView!
    

    @IBAction func addToFavouritesTapped(_ sender: Any) {
        if recipeItem.isFavourite {
            addToFavouritesButton.tintColor = UIColor.systemBlue
            self.recipeItem.isFavourite = !self.recipeItem.isFavourite
        } else {
            addToFavouritesButton.tintColor = UIColor.brown
            self.recipeItem.isFavourite = !self.recipeItem.isFavourite
        }
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("no save: \(error)")
        }
        addToFavouritesButton.isSelected = !addToFavouritesButton.isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToFavouritesButton.setTitle("Убрать из избранного", for: .normal)
        addToFavouritesButton.setTitle("Добавить в избранное", for: .selected)
        addToFavouritesButton.isSelected = !recipeItem.isFavourite
        
        if recipeItem.isFavourite {
            addToFavouritesButton.tintColor = UIColor.brown
        } else {
            addToFavouritesButton.tintColor = UIColor.systemBlue
        }
        
        var recipeDetailText = ""
        let steps = recipeItem.steps ?? ""
        let arrayOfSteps = steps.components(separatedBy: "$%$")
        if arrayOfSteps.count == 1 {
            recipeDetailText += "    \(arrayOfSteps[0])"
        } else {
            for i in 0...arrayOfSteps.count-1 {
                recipeDetailText += "\(i+1). \(arrayOfSteps[i])"
                if i != arrayOfSteps.count-1 {
                    recipeDetailText += "\n\n"
                }
            }
        }
        let ingredients = recipeItem.ingredients ?? ""
        arrayOfIngredients = ingredients.components(separatedBy: ";")
        
        let myImage: UIImage = UIImage(data: recipeItem.img!) ?? UIImage(named: defaultImg)!
        recipeNameLabel.text = recipeItem.name
        recipeMatchLabel.text = "Совпало \(recipeItem.ingridMatchCount) из \(recipeItem.ingridCount) ингредиентов"
        recipeGroupLabel.text = ["Подборка: ", recipeItem.group].compactMap { $0 }
        .joined(separator: " ")
        recipeDifficultyLabel.text = ["Сложность: ", recipeItem.difficulty].compactMap { $0 }
        .joined(separator: " ")
        recipeImage.image = myImage
        recipeDetailTextView.text = recipeDetailText

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ingridientsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.ingridientsTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.ingridientsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.ingridientsTableHeight.constant = newSize.height
                }
            }
        }
    }

}

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfIngredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ingridientId", for: indexPath) as? IngredientsDetailViewCell {
            cell.ingridName.text = arrayOfIngredients[indexPath.row]
            if arrayOfUserIngridients.contains(recipeItem.ingridNormalIndex![indexPath.row]) {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}
