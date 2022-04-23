//
//  TrainingViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 16.04.2022.
//

import UIKit

class TrainingViewController: UIViewController {
    
    var currentScreen: Int = 0
    var currentStyleScreen: ButtonsStyle = .first
    
    enum ButtonsStyle {
        case first
        case main
        case last
    }
    
    struct TrainingScreen {
        let index: Int
        let text: String
        let buttonStyle: ButtonsStyle
        init(index: Int, text: String, buttonStyle: ButtonsStyle) {
            self.index = index
            self.text = text
            self.buttonStyle = buttonStyle
        }
    }
    
    let screens = [ TrainingScreen(index: 1, text: "Привет! На этом экране вы можете научиться пользоваться этим приложением. Хотите пройти обучение?", buttonStyle: .first),
                    TrainingScreen(index: 2, text: "Это главный экран. Здесь вы увидите список игредиентов, которые имеются у вас на кухне. Чтобы удалить ненужный ингредиент достаточно свайпнуть его влево.", buttonStyle: .main),
                    TrainingScreen(index: 3, text: "Чтобы добавить новый ингредиент нажмите на плюс вверху экрана.", buttonStyle: .main),
                    TrainingScreen(index: 4, text: "Там вы увидите список всех категорий. Выберите ту, которая вам необходима...", buttonStyle: .main),
                    TrainingScreen(index: 5, text: "... и добавьте нужный ингредиент =)", buttonStyle: .main),
                    TrainingScreen(index: 6, text: "Также вы можете задать значимость для каждого ингредиента.", buttonStyle: .main),
                    TrainingScreen(index: 7, text: "Если вам нравится или не нравится какой-то ингредиент - просто укажите это и мы сможем более точно сформировать подборку рецептов!", buttonStyle: .main),
                    TrainingScreen(index: 8, text: "На экране \"Рецепты\" вы сможете увидеть подборку рецептов, которую мы для вас сформировали. У каждого рецепта имеется маркер, где показывается отношение количества имеющихся ингредиентов к количеству ингредиентов, необходимых для приготовления рецепта.", buttonStyle: .main),
                    TrainingScreen(index: 9, text: "Нажав на данную кнопку вы можете задать фильтры для рецептов.", buttonStyle: .main),
                    TrainingScreen(index: 10, text: "Выберите необходимые параметры и получите интересующую вас подборку!", buttonStyle: .main),
                    TrainingScreen(index: 11, text: "Если у вас имеется какой-то рецепт, который вам хочется добавить в наше приложение, то вы можете это сделать! Нажмите на эту кнопку и добавьте новый рецепт!", buttonStyle: .main),
                    TrainingScreen(index: 12, text: "Также любой рецепт можно добавить в избранное. Достаточно открыть рецепт и нажать одноимённую кнопку.", buttonStyle: .last) ]
    
    
    var endOfEducation: EndOfEducation = EndOfEducation()
    
    @IBOutlet weak var trainingImage: UIImageView!
    @IBOutlet weak var trainingLabel: UILabel!
    @IBOutlet weak var trainingPageControl: UIPageControl!
    
    @IBOutlet weak var leftBut: UIButton!
    @IBOutlet weak var rightBut: UIButton!
    
    
    @IBAction func leftButton(_ sender: Any) {
        switch currentStyleScreen {
        case .first:
            dismiss(animated: true)
        case .main:
            if currentScreen == 1 {
                currentStyleScreen = .first
            }
            currentScreen -= 1
            buildScreen(currentScreen: currentScreen, currentStyleScreen: currentStyleScreen, item: screens[currentScreen])
        case .last:
            currentStyleScreen = .main
            
            currentScreen -= 1
            buildScreen(currentScreen: currentScreen, currentStyleScreen: currentStyleScreen, item: screens[currentScreen])
        }
        
    }
    
    @IBAction func rightButton(_ sender: Any) {
        switch currentStyleScreen {
        case .last:
            dismiss(animated: true)
        case .first:
            currentScreen += 1
            currentStyleScreen = .main
            buildScreen(currentScreen: currentScreen, currentStyleScreen: currentStyleScreen, item: screens[currentScreen])
        case .main:
            if currentScreen == 10
            {
                currentStyleScreen = .last
            }
            currentScreen += 1
            buildScreen(currentScreen: currentScreen, currentStyleScreen: currentStyleScreen, item: screens[currentScreen])
        }
    }
    
    func buildScreen(currentScreen: Int, currentStyleScreen: ButtonsStyle, item: TrainingScreen) {
    
        switch currentStyleScreen {
        case .first:
            leftBut.setTitle("Закрыть", for: .normal)
            rightBut.setTitle("Начать", for: .normal)
        case .main:
            leftBut.setTitle("Назад", for: .normal)
            rightBut.setTitle("Далее", for: .normal)
        case .last:
            leftBut.setTitle("Назад", for: .normal)
            rightBut.setTitle("Закрыть", for: .normal)
        }
        
        UIView.transition(with: trainingImage,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { self.trainingImage.image = UIImage(named: currentStyleScreen == .first ? "logo" : "education_" + String(item.index-1) ) ?? UIImage(named: "noPhoto.jpg")! },
                          completion: nil)
        
        UIView.transition(with: trainingLabel,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { self.trainingLabel.text = item.text },
                          completion: nil)
        
        trainingPageControl.currentPage = currentScreen
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildScreen(currentScreen: currentScreen, currentStyleScreen: currentStyleScreen, item: screens[currentScreen])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.endOfEducation.closed = true
    }
}





















//
//  ViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 15.06.2021.
//
// Splash screen

//import UIKit
//import CoreData
//
//
//public class EndOfEducation {
//    var closed: Bool = false
//
//    init() {
//        self.closed = false
//    }
//}
//
//class ViewController: UIViewController {
//
//
//
//    @IBOutlet weak var logoImg: UIImageView!
//    @IBOutlet weak var activity: UIActivityIndicatorView!
//
//    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var recipes: [Recipe] = []
//    var allIngrids: [MainIngridient] = []
//    var allIngridients: [Ingridient] = []
//
//    var endOfEducation: EndOfEducation = EndOfEducation()
//
//    // MARK: - GET DATA FROM FILE
//
//    func getDataFrom() {
//
//        // print("getdtatatatatingrid")
//        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name != nil")
//        // fetchRequest.delegate = self
//
//        var records = 0
//        do {
//            records = try context.count(for: fetchRequest)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        guard records == 0 else {
//            return
//        }
//
//
//        guard let pathToFile = Bundle.main.path(forResource: "normalIngrid", ofType: "plist") else {
//            return
//
//        }
//        let dataArray = NSArray(contentsOfFile: pathToFile)!
//
//        for (index, dictionary) in dataArray.enumerated() {
//            let entity = NSEntityDescription.entity(forEntityName: "Ingridient", in: context)
//            let ingrid = NSManagedObject(entity: entity!, insertInto: context) as! Ingridient
//            let ingridDictionary = dictionary as! [String : Any]
//            ingrid.curIndex = Int32(index)
//            ingrid.name = ingridDictionary["name"] as? String
//            ingrid.index = ingridDictionary["index"] as? String
//            ingrid.category = ingridDictionary["category"] as! Int32
//            ingrid.added = false
//            ingrid.weight = Double(1)
//        }
//
//        do {
//            allIngridients = try context.fetch(fetchRequest)
//            //allIngridients.sort(by: { $0.name! < $1.name! })
//
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    func getDataFromAllIngrids() {
//
//        let fetchRequest: NSFetchRequest<MainIngridient> = MainIngridient.fetchRequest()
//
//        var records = 0
//        do {
//            records = try context.count(for: fetchRequest)
//            print("Data is there already")
////            let trainingVC = storyboard?.instantiateViewController(withIdentifier: "training")
////            present(trainingVC!, animated: true)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        guard records == 0 else {
//            return
//        }
//
//        guard let pathToFile = Bundle.main.path(forResource: "allIngrid", ofType: "plist") else {
//            return
//
//        }
//        let dataArray = NSArray(contentsOfFile: pathToFile)!
//
//        for dictionary in dataArray {
//            let entity = NSEntityDescription.entity(forEntityName: "MainIngridient", in: context)
//            let ingrid = NSManagedObject(entity: entity!, insertInto: context) as! MainIngridient
//            let ingridDictionary = dictionary as! [String : Any]
//            ingrid.name = ingridDictionary["name"] as? String
//            ingrid.index = ingridDictionary["index"] as! Int32
//        }
//    }
//
//    func getDataFromRecipes() {
//        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
//
//        var records = 0
//        do {
//            records = try context.count(for: fetchRequest)
//            print("Data is there already")
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        guard records == 0 else {
//            return
//        }
//
//        guard let pathToFile = Bundle.main.path(forResource: "recipes_1", ofType: "plist") else {
//            return
//
//        }
//        let dataArray = NSArray(contentsOfFile: pathToFile)!
//
//        for dictionary in dataArray {
//            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)
//            let recipe = NSManagedObject(entity: entity!, insertInto: context) as! Recipe
//            let recipeDictionary = dictionary as! [String : String]
//            recipe.name = recipeDictionary["name"]
//            recipe.difficulty = recipeDictionary["difficulty"]
//            recipe.group = recipeDictionary["group"]
//            recipe.ingredients = recipeDictionary["ingredients"]
//            recipe.steps = recipeDictionary["steps"]
//
//            recipe.img = (UIImage(named: recipeDictionary["img"] ?? "noPhoto.jpg") ?? UIImage(named: "noPhoto.jpg")!).pngData()
//            let ingrids = recipeDictionary["ingredients"]!.components(separatedBy: ";")
//            recipe.ingridCount = Int16(ingrids.count)
//            recipe.ingridMatch = 0
//            recipe.ingridMatchCount = 0
//            recipe.isMine = false
//
//            // ingridIndex
//            var ingridIndex: Array<Int> = []
//
//            for ingrid in ingrids {
//                ingridIndex.append(Int(allIngrids.filter{ $0.name!.contains(ingrid) }[0].index))
//            }
//            recipe.ingridIndex = ingridIndex as [Int]
//
//
//
//            // ingridNormalIndex
//            var ingridNormalIndex: Array<Int> = []
//            for ingrid in ingridIndex {
//                guard let newIndex = Optional(Int(allIngridients.filter{ $0.index!.components(separatedBy: ";").contains(String(ingrid)) }[0].curIndex)) else { return }
//                ingridNormalIndex.append(newIndex)
//            }
//
//            recipe.ingridNormalIndex = ingridNormalIndex as [Int]
//
//        }
//
//    }
//
////    func qwerty() {
////        let serialQueue = DispatchQueue(label: "serial-queue")
////
////
////        let group = DispatchGroup()
////
////        let workItem1 = DispatchWorkItem {
////
////            self.getDataFrom()
////            print("lol1")
////            group.leave()
////        }
////
////        let workItem2 = DispatchWorkItem {
////
////            self.getDataFromAllIngrids()
////            print("lol2")
////            group.leave()
////        }
////
////        let workItem3 = DispatchWorkItem {
////            print("lol3")
////            let fetchAllIngridsRequest: NSFetchRequest<MainIngridient>  = MainIngridient.fetchRequest()
////            do {
////                self.allIngrids = try self.context.fetch(fetchAllIngridsRequest)
////
////            } catch {
////                Swift.print("errorRR")
////            }
////            print("lol4")
////            group.leave()
////        }
////
////        let workItem4 = DispatchWorkItem {
////            print("lol5")
////            self.getDataFromRecipes()
////            group.leave()
////
////        }
////
////
////        print("lol0")
////
////
////        group.enter()
////        serialQueue.async(execute: workItem1)
////        group.wait()
////        group.enter()
////        serialQueue.async(execute: workItem2)
////        group.wait()
////        group.enter()
////        serialQueue.async(execute: workItem3)
////        group.wait()
////        group.enter()
////        serialQueue.async(execute: workItem4)
////        group.wait()
////
////        print("lol99")
////    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        DispatchQueue.global().async {
//
//
//            self.getDataFrom()
//            print("lol1")
//
//            self.getDataFromAllIngrids()
//            print("lol2")
//
//            print("lol3")
//            let fetchAllIngridsRequest: NSFetchRequest<MainIngridient>  = MainIngridient.fetchRequest()
//            do {
//                self.allIngrids = try self.context.fetch(fetchAllIngridsRequest)
//
//            } catch {
//                Swift.print("errorRR")
//            }
//            print("lol4")
//
//
//            print("lol5")
//            self.getDataFromRecipes()
//
//
//
//
//            DispatchQueue.main.async {
//                print("kek2")
//                self.activity.startAnimating()
//                self.logoImg.image = UIImage(named: "logo")
//                print("kek33")
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "training") as! TrainingViewController
//                vc.endOfEducation = self.endOfEducation
//                self.present(vc, animated: true, completion: nil)
//
//            }
//        }
//    }
//}
