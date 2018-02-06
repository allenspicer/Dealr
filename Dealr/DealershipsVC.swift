//
//  DealershipsVC.swift
//  Dealr
//
//  Created by Allen Spicer on 11/1/17.
//  Copyright © 2017 Allen Spicer. All rights reserved.
//


import Foundation
import UIKit
import MessageUI
import CoreData

class DealershipsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate  {
    
    var newListTitle = String()
    var newListCount = Int()
    
    var dealershipListData = [[String]]()
    var dealershipEmailsData = [[String]]()

    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "dealer_cell"
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        checkForData()
        
        dealershipListData = [["Example: Within 50 Miles","20","Subaru","Forester"], ["Example: Within 100 Miles","50","Subaru","Forester"]]
        dealershipEmailsData = [["dealer1@gmail.com","dealer@gmail.com"], ["dealer2@gmail.com","dealer@gmail.com"]]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let customTabBarController = self.tabBarController as? NewCarTabBarController {
            if (customTabBarController.isNewData){
                
                dealershipListData.append(customTabBarController.dealershipListData[0])
                for emails in customTabBarController.dealershipEmailsData{
                    dealershipEmailsData.append(emails)
                }
                customTabBarController.isNewData = false
                tableView.reloadData()
            }
        }
    }
    
    // MARK : Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealershipListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DealershipTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DealershipTableViewCell!
        
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.dealershipListTitleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.dealershipCountLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cell.dealershipListTitleLabel.text = self.dealershipListData[indexPath.row][0]
        cell.dealershipCountLabel.text = self.dealershipListData[indexPath.row][1] + " dealers"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You tapped cell number \(indexPath.row).")
        composeEmailWithDealershipRecipients(index: indexPath.row)
//        self.checkForData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            self.dealershipListData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
    
    
// MARK: Email Composing and Handling
    
    func composeEmailWithDealershipRecipients( index:Int) {
        
        let makeString = dealershipListData[index][2]
        let modelString = dealershipListData[index][3]

        if (MFMailComposeViewController.canSendMail()){
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self

            // Configure the fields of the interface.
            let dealershipEmailsForChosenList = self.dealershipEmailsData[index]
            composeVC.setBccRecipients(dealershipEmailsForChosenList)
            composeVC.setSubject("Help with a new \(makeString) \(modelString)")
            composeVC.setMessageBody("I'm looking for a new \(modelString) and would apperciate your help",
                                     isHTML: false)

            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Return from email modal. Handle whether it completed or not.
        //Check the result or perform other tasks.

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    func checkForData(){
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dealers")
//        request.returnsObjectsAsFaults = false
//
//        do {
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "name") as! String)
////                print(data.value(forKey: "count") as! String)
//
////                print(data.value(forKey: "email1") as! String)
////                print(data.value(forKey: "email2") as! String)
////                print(data.value(forKey: "make") as! String)
////                dealershipLists
//            }
//            print("total objects  = " + String(result.count))
//        } catch {
//            print("Failed")
//        }
        
        
        
//        self.tableView.reloadData()

        
//        //1
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return
//        }
//        
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//
//        //2
//        let fetchRequest =
//            NSFetchRequest<NSManagedObject>(entityName: "Person")
//
//        //3
//        do {
//            people = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
        
//        self.dealershipLists.append(DealershipList.sharedInstance.name)
//        self.dealershipCountsList.append("\(DealershipList.sharedInstance.count)")
//        dealershipsEmailsArray.append(DealershipList.sharedInstance.email)
//        self.tableView.reloadData()
    }
    
    
    
}
