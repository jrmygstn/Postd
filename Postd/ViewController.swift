//
//  ViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/2/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // Outlets
    
    @IBOutlet var features: UIScrollView!
    @IBOutlet var paging: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        features.delegate = self
        let slides:[FeaturesView] = createSlides()
        loadFeatures(slides: slides)
        paging.numberOfPages = slides.count
        paging.currentPage = 0
        view.bringSubview(toFront: paging)
    }

    // Actions
    
    @IBAction func doneButton(_ sender: Any) {
        let tab1 = storyboard?.instantiateViewController(withIdentifier: "loginView")
        self.present(tab1!, animated: false, completion: nil)
    }
    
    
    // Functions
    
    func createSlides() -> [FeaturesView] {
        let slide1:FeaturesView = Bundle.main.loadNibNamed("Features", owner: self, options: nil)?.first as! FeaturesView
        slide1.headerText.text = "CAPTURE THE MOMENT"
        slide1.subText.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        slide1.image.image = UIImage(named: "")
        
        let slide2:FeaturesView = Bundle.main.loadNibNamed("Features", owner: self, options: nil)?.first as! FeaturesView
        slide2.headerText.text = "SELECT AN ORGANIZATION"
        slide2.subText.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        slide2.image.image = UIImage(named: "")
        
        let slide3:FeaturesView = Bundle.main.loadNibNamed("Features", owner: self, options: nil)?.first as! FeaturesView
        slide3.headerText.text = "SHARE YOUR STORY"
        slide3.subText.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        slide3.image.image = UIImage(named: "")
        
        return [slide1, slide2, slide3]
    }
    
    func loadFeatures(slides: [FeaturesView]) {
        features.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        features.contentSize = CGSize(width: view.frame.width * CGFloat (slides.count), height: view.frame.height)
        features.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            features.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        paging.currentPage = Int(pageIndex)
    }

}

