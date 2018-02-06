//
//  NewCarTabBarController.swift
//  Dealr
//
//  Created by Allen Spicer on 11/1/17.
//  Copyright © 2017 Allen Spicer. All rights reserved.
//

import UIKit

class NewCarTabBarController: UITabBarController, UITabBarControllerDelegate{
    
    var dealershipListData = [[String]]()
    var dealershipEmailsData = [[String]]()
    var isNewData = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        

        
//        if (selectedIndex == 1){
//            let dealershipsVC = self.viewControllers![1] as! DealershipsVC
//            dealershipsVC.dealershipListData = dealershipListData
//            dealershipsVC.dealershipEmailsData = dealershipEmailsData
//        }
    }
    
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        let newCarVC = self.viewControllers![1] as! NewCarVC
//        let dealershipsVC = self.viewControllers![2] as! DealershipsVC
//        dealershipsVC.dealershipLists.append(newCarVC.dealershipListName)
    }
    
//    func NewCarTabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//
//        let newCarVC = self.viewControllers![1] as! NewCarVC
//        let dealershipsVC = self.viewControllers![2] as! DealershipsVC
//        dealershipsVC.dealershipLists.append(newCarVC.dealershipListName)
//    }
    
}
