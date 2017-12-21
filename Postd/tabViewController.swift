//
//  tabViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/20/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit

class tabViewController: UIViewController, UIScrollViewDelegate {
    
    // Outlets
    
    @IBOutlet var tips: TipsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Onboarding sets
        
        tips.delegate = self
        let slides:[TipsView] = createSlides()
        loadTips(slides: slides)
        
    }
    
    // Actions
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Functions
    
    func createSlides() -> [TipsView] {
        let slide1:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide1.imageView.image = UIImage(named: "tip01-img")
        slide1.headerText.text = "MAKING PROGRESS"
        slide1.bodyText.text = "Capture content that represents advancement, development of better conditions, or onward movement."
        slide1.numberText.text = "1 OF 10"
        
        let slide2:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide2.imageView.image = UIImage(named: "tip02-img")
        slide2.headerText.text = "ENCOURAGEMENT TO STAY STRONG"
        slide2.bodyText.text = "Capture content that stimulates continued support, confidence, or hope."
        slide2.numberText.text = "2 OF 10"
        
        let slide3:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide3.imageView.image = UIImage(named: "tip03-img")
        slide3.headerText.text = "CHARITABLE SUPPORT"
        slide3.bodyText.text = "Capture content that suggests a call-to-action to give money or goods for a positive cause."
        slide3.numberText.text = "3 OF 10"
        
        let slide4:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide4.imageView.image = UIImage(named: "tip04-img")
        slide4.headerText.text = "EXPRESS APPRECIATION"
        slide4.bodyText.text = "Capture content that expresses gratitude for money, goods, or services rendered."
        slide4.numberText.text = "4 OF 10"
        
        let slide5:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide5.headerText.text = "NEED VOLUNTEERS"
        slide5.bodyText.text = "Capture content that expresses a need for volunteers who will freely take part in events or tasks."
        slide5.numberText.text = "5 OF 10"
        
        let slide6:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide6.headerText.text = "PROMOTING AN EVENT"
        slide6.bodyText.text = "Capture content announcing an event, cause, or venture for public awareness."
        slide6.numberText.text = "6 OF 10"
        
        let slide7:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide7.headerText.text = "PUBLIC FIGURE"
        slide7.bodyText.text = "Capture content utilizing public figure influence to develop or shape social change."
        slide7.numberText.text = "7 OF 10"
        
        let slide8:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide8.headerText.text = "BE TRANSPARENT"
        slide8.bodyText.text = "Capture content that showcases transparency in your processes."
        slide8.numberText.text = "8 OF 10"
        
        let slide9:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide9.headerText.text = "ON LOCATION"
        slide9.bodyText.text = "Capture content that highlights a specific on-sight location as a supported area."
        slide9.numberText.text = "9 OF 10"
        
        let slide10:TipsView = Bundle.main.loadNibNamed("Tips", owner: self, options: nil)?.first as! TipsView
        slide10.headerText.text = "CAMPAIGNING"
        slide10.bodyText.text = "Capture content of specific actions or activities from supporters taking part in campaigns."
        slide10.numberText.text = "10 OF 10"
        
        return [slide1, slide2, slide3, slide4, slide5, slide6, slide7, slide8, slide9, slide10]
    }
    
    func loadTips(slides: [TipsView]) {
        tips.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tips.contentSize = CGSize(width: view.frame.width * CGFloat (slides.count), height: view.frame.height)
        tips.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            tips.addSubview(slides[i])
        }
    }
    
}
