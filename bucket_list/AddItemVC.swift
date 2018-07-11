//
//  AddItemVC.swift
//  bucket_list
//
//  Created by J on 7/10/2018.
//  Copyright © 2018 Jman. All rights reserved.
//
// ======== ADD ITEM VC =============
import UIKit

class AddItemVC: UITableViewController {

    
    @IBOutlet weak var textField: UITextField!
    
    var item: String = ""
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = item
    }

    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        print("cancelPressed")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        print("savePressed")
        performSegue(withIdentifier: "unwindToVC", sender: self)
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
