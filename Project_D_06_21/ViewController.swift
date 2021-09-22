//
//  ViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 15.06.2021.
//
// Splash screen

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recipes: [Recipe] = []
    var allIngrids: [MainIngridient] = []
    var allIngridients: [Ingridient] = []

    
    
    // MARK: - GET DATA FROM FILE
    
    func getDataFrom() {
        
        // print("getdtatatatatingrid")
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name != nil")
        // fetchRequest.delegate = self
        
        do {
            allIngridients = try context.fetch(fetchRequest)
            //allIngridients.sort(by: { $0.name! < $1.name! })

        } catch {
            print(error.localizedDescription)
        }
        var records = 0
        do {
            records = try context.count(for: fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        guard records == 0 else {
            return
        }
    
        
        guard let pathToFile = Bundle.main.path(forResource: "normalIngrid", ofType: "plist") else {
            return
            
        }
        let dataArray = NSArray(contentsOfFile: pathToFile)!

        for dictionary in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Ingridient", in: context)
            let ingrid = NSManagedObject(entity: entity!, insertInto: context) as! Ingridient
            let ingridDictionary = dictionary as! [String : Any]
            ingrid.name = ingridDictionary["name"] as? String
            ingrid.index = ingridDictionary["index"] as? String
            ingrid.category = ingridDictionary["category"] as! Int32
            ingrid.added = false
        }
    }
    
    func getDataFromAllIngrids() {
        
        let fetchRequest: NSFetchRequest<MainIngridient> = MainIngridient.fetchRequest()

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
        
        guard let pathToFile = Bundle.main.path(forResource: "allIngrid", ofType: "plist") else {
            return
            
        }
        let dataArray = NSArray(contentsOfFile: pathToFile)!

        for dictionary in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "MainIngridient", in: context)
            let ingrid = NSManagedObject(entity: entity!, insertInto: context) as! MainIngridient
            let ingridDictionary = dictionary as! [String : Any]
            ingrid.name = ingridDictionary["name"] as? String
            ingrid.index = ingridDictionary["index"] as! Int32
        }
 
        
    }
    
    func getDataFromRecipes() {
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
            // print(recipeDictionary["name"])
            let ingrids = recipeDictionary["ingredients"]!.components(separatedBy: ";")
            recipe.ingridCount = Int16(ingrids.count)
            recipe.ingridMatch = 0
            print()
            var result: Array<Int32> = []
            for ingrid in ingrids {
                result.append(allIngrids.filter{$0.name!.contains(ingrid) }[0].index as Int32)
            }
            // print(ingrids)
            recipe.ingridIndex = result as NSObject
            // print(result)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()
        logoImg.image = UIImage(named: "logo")
        
        DispatchQueue.main.async {
            self.getDataFrom()
        }
        DispatchQueue.main.async {
            self.getDataFromAllIngrids()
            let fetchAllIngridsRequest: NSFetchRequest<MainIngridient>  = MainIngridient.fetchRequest()
            do {
                self.allIngrids = try self.context.fetch(fetchAllIngridsRequest)

            } catch {
                print(error.localizedDescription)
            }
        }
        DispatchQueue.main.async {
            self.getDataFromRecipes()
            self.activity.stopAnimating()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            self.performSegue(withIdentifier: "mainPage", sender: nil)
            
        }
    )}


}

