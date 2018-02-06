//
//  NewCarVC.swift
//  Dealr
//
//  Created by Allen Spicer on 11/1/17.
//  Copyright © 2017 Allen Spicer. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire

class NewCarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var radiusSelected: String = ""
    var makeWasSelected: Bool = false
    var makeSelected: String = ""
    var indexOfMakeSelected = Int()
    var modelSelected: [String] = []
    var dealershipListName: String = ""
    var dealershipCount = Int()
    var dealers: [[String]] = []
    var makesAndModels: [[String]] = []
    var dealershipDataArray = [[String : String]]()
    var userZip: String = ""
    
    
    //    let makesAndModels = ["Acura" : ["RDX", "MDX", "TLX", "ILX", "RLX"], "Chevrolet" :["Silverado", "Equinox","Cruze","Malibu"],"Subaru":["Outback"], "Toyota":["Highlander", "Tacoma", "Tundra"]]
    
    // Data model: These strings will be the data for the table view cells
    let radiusArray: [String] = ["10","50","100", "500", "All"]
    
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var composeDealerListButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var ModelsAndMakesTableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var zipTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatButton()
        setupKeyboardForZip()
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.ModelsAndMakesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        ModelsAndMakesTableView.delegate = self
        ModelsAndMakesTableView.dataSource = self
        
        var data = readDataFromCSV(fileName: "dealerships", fileType: "csv")
        data = cleanRows(file: data!)
        dealers = csv(data: data!)
        tableView.reloadData()
        
        var makesAndModelsData = readDataFromCSV(fileName: "makesmodels", fileType: "csv")
        makesAndModelsData = cleanRows(file: makesAndModelsData!)
        makesAndModels = csv(data: makesAndModelsData!)
        

        }
    
    func setupKeyboardForZip(){
        zipTextField.becomeFirstResponder()
        zipTextField.keyboardType = .numberPad
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func formatButton(){
        self.composeDealerListButton.layer.cornerRadius = composeDealerListButton.frame.height/2
        self.composeDealerListButton.isEnabled = false
        self.composeDealerListButton.titleLabel?.numberOfLines = 1
        self.composeDealerListButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.composeDealerListButton.titleLabel?.lineBreakMode = .byClipping
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView{
            return self.radiusArray.count
        }
        
        if tableView == self.ModelsAndMakesTableView{
            if (makeWasSelected){
                return (makesAndModels[indexOfMakeSelected].count - 1)
            }else if (!makeWasSelected){
                return makesAndModels.count
            }
        }
        return 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell = UITableViewCell(style: UITableViewCellStyle.value1,
                               reuseIdentifier: cellReuseIdentifier)
        
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        if tableView == self.tableView{
            cell.textLabel?.text = self.radiusArray[indexPath.row] + " miles"
        }
        
        if tableView == self.ModelsAndMakesTableView && !makeWasSelected{
            cell.textLabel?.text = makesAndModels[indexPath.row][0]
        }
        
        if tableView == self.ModelsAndMakesTableView && makeWasSelected{
            cell.textLabel?.text = makesAndModels[indexOfMakeSelected][(indexPath.row + 1)]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView{
            resetAllRadiusOptions()
            radiusSelected = radiusArray[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath)
            cell?.detailTextLabel?.text = "✔️"
        }
        
        if tableView == self.ModelsAndMakesTableView && makeWasSelected{
            let cell = ModelsAndMakesTableView.cellForRow(at: indexPath)
            if(cell?.detailTextLabel?.text == "✔️"){
                let modelToRemoveString = makesAndModels[indexOfMakeSelected][(indexPath.row + 1)]
                modelSelected.remove(at: modelSelected.index(of: modelToRemoveString)!)
                cell?.detailTextLabel?.text = ""
                self.ModelsAndMakesTableView.reloadData()
                if (modelSelected.count < 1){
                    composeDealerListButton.isEnabled = false
                }
            }
            cell?.detailTextLabel?.text = "✔️"
            composeDealerListButton.isEnabled = true
            modelSelected.append(makesAndModels[indexOfMakeSelected][(indexPath.row + 1)])
        }
        
        if tableView == self.ModelsAndMakesTableView && !makeWasSelected{
            makeWasSelected = true
            makeSelected = makesAndModels[indexPath.row][0]
            indexOfMakeSelected = indexPath.row
            self.ModelsAndMakesTableView.reloadData()
        }
        
    }
    
    func resetAllRadiusOptions(){
        radiusSelected = ""
        tableView.reloadData()
    }
    
    @IBAction func resetButtonWasTapped(_ sender: UIButton) {
        resetAllRadiusOptions()
        makeWasSelected = false
        makeSelected = ""
        modelSelected = []
        ModelsAndMakesTableView.reloadData()
    }
    
    
    @IBAction func composeDealerListButtonWasTapped(_ sender: UIButton) {
        
//        let count = zipTextField.text?.count
        if (!(zipTextField.text?.isEmpty)!){
            userZip = zipTextField.text!
            setDealersForList {
                alertUserToDealerTotalAndOptions()
            }
        }else{
            let alert = UIAlertController(title: "Zip Code Missing",
                                          message: "Please enter your location",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertActionStyle.cancel,
                                          handler:{ (action:UIAlertAction!) in
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setDealersForList(finished: () -> Void){
        
        //find relevant dealers for user
        for dealer in dealers{
            if dealer[0] == makeSelected{
                dealershipDataArray.append(["name":"\(dealer[1])", "city":"Wilmington", "email1":"\(dealer[2])", "email2":"\(dealer[3])", "zip":"\(dealer[8])"])
            }
        }
        dealershipCount = dealershipDataArray.count
        calculateDistanceForDealerships()
        finished()
    }
    
    
    func alertUserToDealerTotalAndOptions(){
        let alert = UIAlertController(title: "Success",
                                      message: "We've completed your search and found \(dealershipCount) eligible dealerships. Enter a name for the list and create it now.",
            preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Save",
                                      style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        self.transitonToDealerListView(nameToSave)
                                        
        })
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertActionStyle.cancel,
                                      handler:{ (action:UIAlertAction!) in
        }))
        
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.keyboardType = UIKeyboardType.default
            textField.placeholder = "Enter Name"
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: transition to list
    
    func transitonToDealerListView(_ titleString: String){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "dealershipList") as! DealershipList
        vc.dealershipDataArray = dealershipDataArray
        vc.titleString = titleString
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    
    // MARK: parsing data from CSV
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    
    func calculateDistanceForDealerships(){
        
        var zipCodeDict = [Int:String]()
        
        for (index, dealer) in dealershipDataArray.enumerated() {
            if let zip = dealer["zip"]{
                if let intZip = Int(zip){
                    if intZip > 1{
                        zipCodeDict[index] = zip
                    }
                }
            }
        }
        var zipCodeString = String()
        for zip in zipCodeDict.values{
            if (zipCodeString.isEmpty){
                zipCodeString = zip
            }else{
                zipCodeString = zipCodeString + ",%20" + zip
            }
        }
        
        let URLString = "https://www.zipcodeapi.com/rest/5j4JqnnBTGRvJn8cnZzGLbtMOwG7yNoFzat5XhAzKaXQ3LnBzLzF50XGJh2o18pZ/multi-distance.json/\(userZip)/\(zipCodeString)/mile"
        print("String for request " + URLString)
        
        Alamofire.request(URLString).responseJSON { response in
            
            switch response.result {
            case .success:
                print("Validation Successful")
                if let json = response.result.value as? [String:Any]{
                    if let dictionary = json["distances"] as? [String:Any]{
                        print(dictionary)
                        
                        //get zip for each entry in zipCodeDict by scrolling through each
                        for zipTuple in zipCodeDict{
                            let zip = zipTuple.value
                            
                            // get mileage from dictionary by using that zip as key
                            if let mileage = dictionary[zip] as? NSNumber{
                                
                                //clean up mileage number
                                let formatter = NumberFormatter()
                                formatter.maximumFractionDigits = 0
                                if let distanceString = formatter.string(from: mileage){
                                    //add mileage to dealershipDataArray by using index from same zipCodeDict entry
                                    self.dealershipDataArray[zipTuple.key]["distance"] = distanceString
                                }
                            }
                        }
                    }
                }
                
            case .failure(let error):
                print("Error in Request:")
                print(error)
            }
        }
    }
    
}

