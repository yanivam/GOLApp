//
//  DetailViewController.swift
//  GOLApp
//
//  Created by Yaniv on 11/26/16.
//  Copyright © 2016 Yaniv Amiri. All rights reserved.
//
import UIKit

class DetailViewController: UIViewController {
    var tableColonyItem: TableColonyItem!
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func blankTempButton(_ sender: UIButton) {
        tableColonyItem.colony.resetColony()
        tableColonyItem.colony.evolutionNumber = 0
        tableColonyItem.template = sender.titleLabel!.text!
    }
    @IBAction func basicTempButton(_ sender: UIButton) {
        tableColonyItem.colony.resetColony()
        tableColonyItem.colony.evolutionNumber = 0
        tableColonyItem.template = sender.titleLabel!.text!
    }
    @IBAction func gliderTempButton(_ sender: UIButton) {
        tableColonyItem.colony.resetColony()
        tableColonyItem.colony.evolutionNumber = 0
        tableColonyItem.template = sender.titleLabel!.text!
    }
    
    @IBOutlet var namingTextField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        namingTextField.text = tableColonyItem.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableColonyItem.templateSetter()
        tableColonyItem.name = namingTextField.text ?? ""
    }
    //
}
