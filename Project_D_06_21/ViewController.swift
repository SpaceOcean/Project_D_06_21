//
//  ViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 15.06.2021.
//
// Splash screen

import UIKit
import CoreData


public class EndOfEducation {
    var closed: Bool = false
    
    init() {
        self.closed = false
    }
}

class ViewController: UIViewController {
    


    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recipes: [Recipe] = []
    var allIngrids: [MainIngridient] = []
    var allIngridients: [Ingridient] = []
    
    var endOfEducation: EndOfEducation = EndOfEducation()
    
    // MARK: - GET DATA FROM FILE
    
    func getDataFrom() {
        
        // print("getdtatatatatingrid")
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name != nil")
        // fetchRequest.delegate = self
        
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

        for (index, dictionary) in dataArray.enumerated() {
            let entity = NSEntityDescription.entity(forEntityName: "Ingridient", in: context)
            let ingrid = NSManagedObject(entity: entity!, insertInto: context) as! Ingridient
            let ingridDictionary = dictionary as! [String : Any]
            ingrid.curIndex = Int32(index)
            ingrid.name = ingridDictionary["name"] as? String
            ingrid.index = ingridDictionary["index"] as? String
            ingrid.category = ingridDictionary["category"] as! Int32
            ingrid.added = false
            ingrid.weight = Double(1)
        }
        
        do {
            allIngridients = try context.fetch(fetchRequest)
            //allIngridients.sort(by: { $0.name! < $1.name! })

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getDataFromAllIngrids() {
        
        let fetchRequest: NSFetchRequest<MainIngridient> = MainIngridient.fetchRequest()

        var records = 0
        do {
            records = try context.count(for: fetchRequest)
            print("Data is there already")
//            let trainingVC = storyboard?.instantiateViewController(withIdentifier: "training")
//            present(trainingVC!, animated: true)
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
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()

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

            recipe.img = (UIImage(named: recipeDictionary["img"] ?? "noPhoto.jpg") ?? UIImage(named: "noPhoto.jpg")!).pngData()
            let ingrids = recipeDictionary["ingredients"]!.components(separatedBy: ";")
            recipe.ingridCount = Int16(ingrids.count)
            recipe.ingridMatch = 0
            recipe.ingridMatchCount = 0
            recipe.isMine = false

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

        }
        
    }
    
    func waitEndOfEducation() {
        
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        var records = 0
        do {
            records = try context.count(for: fetchRequest)
            print("Data is there already")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        guard records == 0,
              !self.endOfEducation.closed else { return }
            while !self.endOfEducation.closed {
                print("fcbar")
                sleep(UInt32(0.01))
            }
    }
    
    func qwerty() {
        print("kek1")
        print("This is run on a background queue")

        print("lol1")
        self.getDataFrom()
        print("lol2")
//
        self.getDataFromAllIngrids()
        print("lol3")
        let fetchAllIngridsRequest: NSFetchRequest<MainIngridient>  = MainIngridient.fetchRequest()
        do {
            self.allIngrids = try self.context.fetch(fetchAllIngridsRequest)

        } catch {
            print(error.localizedDescription)
        }
        
            print("kek3")
        print("lol4")
        
        
        
        self.getDataFromRecipes()
        

        do {
            try context.save()
        } catch let error as NSError {
            print("no save: \(error)")
        }
        
        waitEndOfEducation()
        
        DispatchQueue.main.async {
            self.activity.stopAnimating()
            self.performSegue(withIdentifier: "mainPage", sender: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
//            let serialQueue = DispatchQueue(label: "serial-queue")
            
            let workItem1 = DispatchWorkItem {
            self.qwerty()
            }
            
            
            let group = DispatchGroup()
            
            DispatchQueue.global().async(group: group, execute: workItem1)
            
            group.notify(queue: DispatchQueue.main) {
//                DispatchQueue.main.async {
//                    self.activity.stopAnimating()
//                    self.performSegue(withIdentifier: "mainPage", sender: nil)
//                }
            }

        }
        
        print("kek2")
        self.activity.startAnimating()
        self.logoImg.image = UIImage(named: "logo")
        
        
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name != nil")
        var records = 0
        do {
            records = try context.count(for: fetchRequest)
            print("Data is there already")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        print("lol5")
        if records == 0 {
            DispatchQueue.main.async {
                print("kek33")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "training") as! TrainingViewController
                vc.endOfEducation = self.endOfEducation
                self.present(vc, animated: true, completion: nil)
            
            }
        }
        
    }

}
