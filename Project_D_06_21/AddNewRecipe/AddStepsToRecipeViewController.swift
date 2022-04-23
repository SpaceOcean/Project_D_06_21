//
//  AddStepsToRecipeViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 16.04.2022.
//

import UIKit

class AddStepsToRecipeViewController: UIViewController, UITextViewDelegate {
    
    var newRecipe: NewRecipe = NewRecipe()
    var stepsEditing: Bool = false
    
    
    @IBOutlet weak var stepsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.stepsTextView.addGestureRecognizer(tap)
        
        self.stepsTextView.autocapitalizationType = .words
        self.stepsTextView.autocorrectionType = .no
        self.stepsTextView.delegate = self
        
        if (newRecipe.steps ?? "").isEmpty {
            self.stepsTextView.text = "Напишите описание вашего рецепта"
            self.stepsTextView.textColor = UIColor.lightGray
        } else {
            self.stepsTextView.text = newRecipe.steps
        }
    }
    
    @objc func dismissKeyboard() {
        
        if stepsEditing {
            self.stepsTextView.resignFirstResponder()
            stepsEditing = false
        } else {
            self.stepsTextView.becomeFirstResponder()
            stepsEditing = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        stepsEditing = true
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Напишите описание вашего рецепта"
            textView.textColor = UIColor.lightGray
        }
        newRecipe.steps = textView.text
    }
}
