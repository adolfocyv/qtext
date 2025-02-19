//
//  ViewController.swift
//  ServerForQLab
//
//  Created by Adolfo García on 20/12/23.
//


import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var readMeButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    @IBAction func startButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toTextModeSegue", sender: self)
    }
    
    
    @IBAction func readMePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toReadMeSegue", sender: self)
    }
    
}
