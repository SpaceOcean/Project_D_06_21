//
//  RecipesViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 15.06.2021.
//

import UIKit
import CoreData

class RecipesViewController: UITableViewController {
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recipes: [Recipe] = []

    func getDataFrom() {
        
        print("getdtatatatat")
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name != nil")

        var records = 0
        do {
            records = try context.count(for: fetchRequest)
            print("Data is there already")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        guard records == 0 else {
            return
        }
        
        guard let pathToFile = Bundle.main.path(forResource: "recipes_1", ofType: "plist") else {
            return
            
        }
        let dataArray = NSArray(contentsOfFile: pathToFile)!

        for dictionary in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)
            let recipe = NSManagedObject(entity: entity!, insertInto: context) as! Recipe
            let recipeDictionary = dictionary as! [String : String]
            recipe.name = recipeDictionary["name"]
            recipe.difficulty = recipeDictionary["difficulty"]
            recipe.group = recipeDictionary["group"]
            recipe.ingredients = recipeDictionary["ingredients"]
            recipe.steps = recipeDictionary["steps"]
            recipe.img = recipeDictionary["img"]
        }
 
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFrom()
        
        print(recipes.count)
        let fetchRequest: NSFetchRequest<Recipe>  = Recipe.fetchRequest()
        do {
            recipes = try context.fetch(fetchRequest)

        } catch {
            print(error.localizedDescription)
        }

    }
    


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        print("recipes")
        print(recipes.count)
        cell.textLabel?.text = recipes[indexPath.row].name
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! RecipeDetailViewController
                dvc.recipeName = self.recipes[indexPath.row].name!
                dvc.recipeImg = self.recipes[indexPath.row].img!
            }
        }
    }


}

