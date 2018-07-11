//
//  ViewController.swift
//  bucket_list
//
//  Created by J on 7/10/2018.
//  Copyright © 2018 Jman. All rights reserved.
//
// ========= MAIN VIEW CONTROLLER ===========
import UIKit
import CoreData

class ViewController: UIViewController {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!

//    var tableData: [String] = ["test", "test2"]
    var tableData: [BucketListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // Create Post
    func createBlist(){
        let blist = BucketListItem(context: context)
        blist.text = "dbtest1"
        blist.created_at = Date()
        appDelegate.saveContext()
    }
    
    // Read ALL
    func fetchAll(){
        let request:NSFetchRequest<BucketListItem> = BucketListItem.fetchRequest()
        do {
            let fetchedLists = try context.fetch(request)
            // Here we can store the fetched data in an array
            tableData = fetchedLists
//            for item in tableData{
//                print(item.text)
//            }
        } catch {
            print(error)
        }
    }

    // DELETE func
//        func delete(blist: BucketListItem){
//            print("inside DELETE")
//            context.delete(blist)
//            do{
//                try context.save()
//            }catch{
//                print("error?", error)
//            }
////            appDelegate.saveContext()
//        }
    
    // save functionality - see if editing or saving
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        let src = segue.source as! AddItemVC
        let text_from_otherVC = src.textField.text!
        
        if let indexPath = src.indexPath {
            //edit
            let item = tableData[indexPath.row]
            item.text = text_from_otherVC
//            tableData[indexPath.row].text = text_from_otherVC
        } else {
            //save from addVC
            let blist = BucketListItem(context: context)
            blist.text = text_from_otherVC
            tableData.append(blist)
        }
        do{
            try context.save()
        }catch{
            print("error?", error)
        }
        print("came back with =>", text_from_otherVC)
        tableView.reloadData()
    }
    
    
    @IBAction func AddPressed(_ sender: UIBarButtonItem) {
        print("AddPressed")
        performSegue(withIdentifier: "AddEditSegue", sender: sender)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check who is sending data to the other side
        if let indexPath = sender as? IndexPath {
            print("came from CELL pressed")
            let text = tableData[indexPath.row].text!
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddItemVC
            dest.item = text
            dest.indexPath = indexPath
        } else {
            print("came from BAR button")
        }
//        // ALT WAY
//        if segue.identifier == "AddItemSegue" {
//            // Set Self as Destination Delegate
//        } else if segue.identifier == "EditItemSegue"copy {
//            // Set Self as Destination Delegate AND Set Item / IndexPath Using Sender
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row].text
        return cell
    }
    
    //edit
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
    }
    

    
    //swipe to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, done in
            
//            self.delete(self.tableData[indexPath.row])
            let varname = self.tableData[indexPath.row]
            self.context.delete(varname)
            do{
                try self.context.save()
            }catch{
                print("error?", error)
            }
//
            print("after DELETE func call")
            self.tableData.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.reloadData()
            self.fetchAll()
            done(true)
        })
        
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfig
    }
    
}
