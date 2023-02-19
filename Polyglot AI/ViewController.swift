//
//  ViewController.swift
//  Polyglot AI
//
//  Created by Alex Paul on 2/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextView!
    @IBOutlet weak var secondTextField: UITextView!
    let networkManager = NetworkManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.clipsToBounds = true
        firstTextField.layer.cornerRadius = 10.0
        
        secondTextField.clipsToBounds = true
        secondTextField.layer.cornerRadius = 10.0
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func translateButton(_ sender: Any) {
        
        guard let inputText = firstTextField.text else {
               print("Input text is empty")
               return
           }
           
           networkManager.getResponse(input: inputText) { result in
               switch result {
               case .success(let outputText):
                   DispatchQueue.main.async {
                       self.secondTextField.text = outputText
                   }
               case .failure(let error):
                   print("Error translating text: \(error)")
               }
           }
        
    }
}

