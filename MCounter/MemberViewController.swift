//
//  MemberViewController.swift
//  MCounter
//
//  Created by apple on 9/20/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {
    @IBOutlet weak var screenTitle: UILabel!
    
    @IBOutlet weak var featuresSubTitle: UILabel!
    @IBOutlet weak var featuresList: UILabel!
    @IBOutlet weak var developmentSubTitle: UILabel!
    @IBOutlet weak var developmentList: UILabel!
    @IBOutlet weak var earlyAccessListLabel: UILabel!
//    @IBOutlet weak var upcomingDetailLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var requestAccessButton: UIButton!
    @IBOutlet weak var earlyMemberTitle: UILabel!
    @IBOutlet weak var earlyMemberdetail: UILabel!
    
    let aboutUs = "We make tools for silent meditators."
    let detail = "Features in development for While’s upcoming subscription:"
    let featureListString = "• History with backup\n• Warmup interval\n• Transfer streak from another app\n• Choice of chimes\n• Night mode"
    let upcomingDetail = "Upcoming features will allow further customization, while maintaining TIM3R's uncluttered design."
    let earlyMemberstring = "Become a member"
    let earlyMemberdetailString = "Members gain access to pre-release features and other upcoming products."
    
    static func instance() -> MemberViewController {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let MemberViewController = storyboard.instantiateViewController(withIdentifier: "MemberViewController") as! MemberViewController
        return MemberViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        setupView()
    }
    
    func setupView() {
        
        self.view.backgroundColor = ThemeSettings.sharedInstance.backgroundColor
        
        featuresSubTitle.textColor = ThemeSettings.sharedInstance.fontColor
        
        featuresList.textColor = ThemeSettings.sharedInstance.fontColor
        developmentSubTitle.textColor = ThemeSettings.sharedInstance.fontColor
        
        developmentList.textColor = ThemeSettings.sharedInstance.fontColor
        
        earlyAccessListLabel.textColor = ThemeSettings.sharedInstance.fontColor
        
        earlyMemberTitle.textColor = ThemeSettings.sharedInstance.fontColor
        
        screenTitle.textColor = ThemeSettings.sharedInstance.fontColor
        earlyMemberdetail.textColor = ThemeSettings.sharedInstance.fontColor
        
        requestAccessButton.layer.cornerRadius = 8
        backButton.setImage(ThemeSettings.sharedInstance.arrowImageLeft, for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Apercu-Light", size: 15)
        backButton.setTitleColor(ThemeSettings.sharedInstance.fontColor, for: .normal)
        
         requestAccessButton.titleLabel?.font = UIFont(name: "Apercu-Light", size: 17)

         Networking.getMembership(actionOnTable: {})
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.hyphenationFactor = 1.0
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font:UIFont(name: "Apercu-Light", size: 15)]

        self.developmentList.attributedText = NSAttributedString(string: detail, attributes:attributes as [NSAttributedString.Key : Any])
        self.featuresList.attributedText = NSAttributedString(string: aboutUs, attributes:attributes as [NSAttributedString.Key : Any])
        
        self.earlyAccessListLabel.attributedText = NSAttributedString(string: featureListString, attributes:attributes as [NSAttributedString.Key : Any])
        
//        self.upcomingDetailLabel.attributedText = NSAttributedString(string: upcomingDetail, attributes:attributes as [NSAttributedString.Key : Any])
       
        self.earlyMemberdetail.attributedText = NSAttributedString(string: earlyMemberdetailString, attributes:attributes as [NSAttributedString.Key : Any])
    }
    
    @IBAction func backToSeatingAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestAccessAction(_ sender: Any) {
        
        if let url = URL(string: "http://meditation.itsastudio.co/") {
            UIApplication.shared.open(url)
        }
        
    }
    

}
