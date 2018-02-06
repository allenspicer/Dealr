//
//  DealershipList.swift
//  Dealr
//
//  Created by Allen Spicer on 11/9/17.
//  Copyright © 2017 Allen Spicer. All rights reserved.
//

import UIKit
import CoreData

class DealershipList: UITableViewController {
    
    
    @IBOutlet weak var titleView: UINavigationItem!
    var dealershipDataArray = [[String : String]]()
    var dealershipEmails = [String]()
    var titleString = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = titleString

//        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nil))
        let save = UIBarButtonItem(title: "Finish and Save", style: .plain, target: self, action: #selector(saveListAndTransition))
        
        self.navigationItem.rightBarButtonItems = [save]
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.navigationController?.navigationBar.tintColor  = #colorLiteral(red: 0, green: 0.7942058444, blue: 0.8017095923, alpha: 1)
        
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dealershipDataArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealershipcellreuseIdentifier", for: indexPath)
        
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.textLabel?.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)

         cell.textLabel?.text = dealershipDataArray[indexPath.row]["name"]
        let distanceString = dealershipDataArray[indexPath.row]["distance"] ?? "?"
         cell.detailTextLabel?.text = "\(distanceString)" + " miles"
        dealershipEmails.append("\(dealershipDataArray[indexPath.row]["email1"] ?? "default@email.com")")
        dealershipEmails.append("\(dealershipDataArray[indexPath.row]["email2"] ?? "default@email.com")")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            self.dealershipDataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
    
    @objc func saveListAndTransition(){
        //use function to save data in core data
//        tryCoreData()
        
        //send user to dealershipsVC only if data saves
        gotoDealershipsVC()

    }
 
    
    func tryCoreData(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "ListOfDealerships", in: context)
//        let list = NSManagedObject(entity: entity!, insertInto: context)
//
//        if let name = titleString as String?{
//            list.setValue("\(name)", forKey: "name")
//        }
//        if let count = dealershipDataArray.count as Int?{
//            list.setValue("\(count)", forKey: "count")
//        }
//
//        do {
//            try context.save()
//            gotoDealershipsVC()
//        } catch {
//            print("Failed saving")
//        }
    
    }

    func gotoDealershipsVC(){
        
        if let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? NewCarTabBarController {
            tabViewController.selectedIndex = 1
            tabViewController.dealershipListData.append([titleString,"\(dealershipDataArray.count)","Subaru","Forester"])
            tabViewController.dealershipEmailsData.append(dealershipEmails)
            tabViewController.isNewData = true
            present(tabViewController, animated: true, completion: nil)
        }
    }


}
