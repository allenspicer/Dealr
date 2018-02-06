//
//  LaunchVC.swift
//  Dealr
//
//  Created by Allen Spicer on 11/1/17.
//  Copyright © 2017 Allen Spicer. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class LaunchVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var getStartedButton: UIButton!

    let scrollView = UIScrollView()
    var playerLooper: NSObject?
    var titleData:[String] = ["Select","Curate", "Contact", "Choose"]
    var pageData:[String] = ["Pick your car and how far you'd go to get it.","Edit your dealer list and save it to your profile.", "Reach out to every dealer on your list to request an out-the-door price", "Decide for yourself who to work with and lock in a competitive price before you step foot in a dealership."]
        
//        ["Find the car dealership you want to work with.","Setup an inbox so spam never gets to your real email.","Select the vehicle you're after and how far you'll go to get it.","Get contacts at each dealership and tell them what you're looking for.","Sort through the offers you like and ask all the dealers compete on your best offer."]
    var frame: CGRect = CGRect()
    var pageControl : UIPageControl = UIPageControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideo()
        addScrollView()
        mainView.alpha = 0.90
        showButton()

        let totalTimeInterval: TimeInterval = 16.0
        _ = Timer.scheduledTimer(timeInterval: (totalTimeInterval/2), target: self, selector: #selector(scrollForward), userInfo: nil, repeats: true)
        
        frame = CGRect(x: view.layoutMargins.left, y: view.layoutMargins.top, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        
        let scrollViewFrameHeight = view.safeAreaLayoutGuide.layoutFrame.height * 0.8
        
        let scrollViewFrame = CGRect(x: view.layoutMargins.left, y: view.layoutMargins.top, width: view.safeAreaLayoutGuide.layoutFrame.width, height: scrollViewFrameHeight)
        
        scrollView.frame = scrollViewFrame
        pageControl.frame = CGRect(x: 50, y: 650, width: 300, height: 50)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        for index in 0..<4 {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            let subView = UIView(frame: frame)
            let contentLabel = UITextView(frame: frame)
            let heightHelper = frame.height * 0.12
            let contentYValue = frame.height + (frame.height * 0.05) + heightHelper
            contentLabel.center = CGPoint(x: frame.width/2, y: contentYValue)
            contentLabel.textAlignment = .center
            contentLabel.text = pageData[index]
            contentLabel.isEditable = false
            contentLabel.font = UIFont(name: "Kailasa", size: 18)
            contentLabel.backgroundColor = UIColor.clear
            subView.addSubview(contentLabel)
            let titleLabel = UITextView(frame: frame)
            let titleYValue = frame.height + heightHelper
            titleLabel.center = CGPoint(x: frame.width/2, y: titleYValue)
            titleLabel.textAlignment = .center
            titleLabel.text = titleData[index]
            titleLabel.isEditable = false
            titleLabel.font = UIFont(name: "Kailasa-Bold", size: 30)
            titleLabel.backgroundColor = UIColor.clear
            subView.addSubview(titleLabel)
            self.scrollView .addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSize(width:(self.scrollView.frame.size.width * CGFloat(pageData.count)),height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "dog_car_launch", ofType:"mp4") else {
            print("video file not found")
            return
        }
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        let player = AVQueuePlayer(items: [playerItem])
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.playerLooper = AVPlayerLooper(player: player , templateItem: playerItem)
        mainView.layer.addSublayer(playerLayer)
//        playerLayer.frame = CGRect(x: -25, y: -25, width: 400, height: 800)
        let videoFrame = CGRect(x: -25, y: -50, width: (self.view.frame.size.width+25), height: self.view.frame.size.height+10)
        playerLayer.frame = videoFrame
        player.play()
        
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = pageData.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.black
//        self.pageControl.currentPageIndicatorTintColor = UIColor.white
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
//        mainView.alpha = 0.3
//        self.view.addSubview(scrollView)
//        configurePageControl()
//        getStartedButton.layer.borderColor = UIColor.clear.cgColor
//        getStartedButton.setTitleColor(UIColor.clear, for: .normal)
        self.performSegue(withIdentifier: "launch_to_home", sender: self)

    }
    
    func showTitle(){
//                self.titleLabel.text = "DealerNetwork"
//                self.titleLabel.font = UIFont(name: "Kailasa Bold", size: 30)
//                self.titleLabel.textColor = UIColor.black
    }
    
    func showButton(){
        getStartedButton.layer.borderWidth = 1
        getStartedButton.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        getStartedButton.layer.cornerRadius = getStartedButton.layer.frame.height/2
        getStartedButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        getStartedButton.titleLabel?.baselineAdjustment = .alignCenters
    }
    
    func addScrollView(){
        self.view.addSubview(scrollView)
        configurePageControl()
    }
    
    @objc func scrollForward() {
        if (self.pageControl.currentPage + 1 < self.pageControl.numberOfPages){
            self.pageControl.currentPage = self.pageControl.currentPage + 1
        }
        else{
            self.pageControl.currentPage = 0
        }
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
}


