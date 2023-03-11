//
//  ViewController.swift
//  Polyglot AI
//
//  Created by Alex Paul on 2/10/23.
//

import UIKit
import Lottie
class ViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextView!
    @IBOutlet weak var secondTextField: UITextView!
    let networkManager = NetworkManager.shared
    var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
       
        // Do any additional setup after loading the view.
    }
    
    
    
    func setUpTextField(){
        firstTextField.clipsToBounds = true
        firstTextField.layer.cornerRadius = 10.0
        secondTextField.clipsToBounds = true
        secondTextField.layer.cornerRadius = 10.0
        secondTextField.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissKeyboard() {
        firstTextField.resignFirstResponder()
    }
    
    @IBAction func translateButton(_ sender: Any) {
        
        guard let inputText = firstTextField.text else {
            print("Input text is empty")
            return
        }
        
        let prompt = "translate from English to Nigerian Pidgin:\n\n\(inputText)\n\nOutput:"
        // Add animation view
                animationView = LottieAnimationView(name: "loading")
                animationView?.frame = view.bounds
                animationView?.contentMode = .scaleAspectFit
                view.addSubview(animationView!)
                animationView?.play()
        
        networkManager.getTranslation(input: prompt) { result in
            DispatchQueue.main.async {
                            self.animationView?.stop()
                            self.animationView?.removeFromSuperview()
                        }
            
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
