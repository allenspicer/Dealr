//
//  HomeVC.swift
//  Dealr
//
//  Created by Allen Spicer on 11/1/17.
//  Copyright © 2017 Allen Spicer. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class HomeVC: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    var pageData:[String] = ["Wheels is a simple tool to make finding your new vehicle easy. In 4 steps you'll go from a vision of the vehicle you want to multiple competing offers you can choose from.","Step 1: Setup an alias. It's time to go undercover. You'll use a new email account to contact dealerships - that way any spam never gets to your real inbox. Go to the Messages tab and setup an new inbox now. Then add that inbox to your iOS mail app.","Step 2: Great! Your inbox is safe, now it's time to choose the vehicle you want and decide how far you're willing to go for it. Go to the NewCar tab and select a vehicle and a distance to get contact information for all the dealerships who might have your car waiting.","Step 3. Almost Done! Open the dealership list in the Dealerships tab and look through the options. You can swipe to delete any you know you won't be buying from. When you're happy with the list hit Contact Dealers Now and send them an email.","Step 4. Your car is waiting! Sort through the offers you like and let them know what your best offer is. They can't compete if they don't know what it is! When you've got an offer you like it's time to print out the offer and go get it!"]
    var frame: CGRect = CGRect()
    var pageControl : UIPageControl = UIPageControl()
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.borderWidth = 1
        getStartedButton.layer.borderColor = UIColor.white.cgColor
        getStartedButton.layer.cornerRadius = getStartedButton.layer.frame.height/2
        
        scrollView.frame = CGRect(x: 10, y: 150, width: 360, height: 600)
        pageControl.frame = CGRect(x: 50, y: 650, width: 300, height: 50)
        
        frame = CGRect(x: view.layoutMargins.left, y: view.layoutMargins.top, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        for index in 0..<5 {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            let subView = UIView(frame: frame)
            let label = UITextView(frame: frame)
            label.center = CGPoint(x: frame.width/2, y: frame.height/2)
            label.textAlignment = .center
            label.text = pageData[index]
            label.font = UIFont(name: "Kailasa", size: 30)
            label.backgroundColor = UIColor.clear
            subView.addSubview(label)
            self.scrollView .addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSize(width:(self.scrollView.frame.size.width * CGFloat(pageData.count)),height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = pageData.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.orange
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    @IBAction func getStartedButtonWasTapped(_ sender: UIButton) {
        backgroundImageView.alpha = 0.3
        self.view.addSubview(scrollView)
        configurePageControl()
        getStartedButton.layer.borderColor = UIColor.clear.cgColor
        getStartedButton.setTitleColor(UIColor.clear, for: .normal)
    }
}



