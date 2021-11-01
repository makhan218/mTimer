//
//  PrivacyViewController.swift
//  MCounter
//
//  Created by apple on 9/20/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit
import JGProgressHUD

class PrivacyViewController: UIViewController {
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var webview: UIWebView!
    let detail = "We make tools for experienced meditators.\n\nMember features allow you to tailor the behavior and appearance of the timer extensively, while keeping the interface unobtrusive for everday use.\n\nMembership gives you access to features in early stages of development and keeps a team focused on the new features you want, while maintaining the simple design that you enjoy."
    
    let hud = JGProgressHUD(style: .extraLight)
    
    static func instance() -> PrivacyViewController {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let PrivacyViewController = storyboard.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
        return PrivacyViewController
    }
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.backgroundColor = .white
        webview.delegate = self
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        if !Reachability.isConnectedToNetwork() {
            if (AppStateStore.shared.privacyPolicy?.count ?? 0) > 1 {
                webview.loadHTMLString(AppStateStore.shared.privacyPolicy ?? "", baseURL: nil)
            }
            else {
                webview.loadHTMLString(privacyPolicy, baseURL: nil)
            }
            
        }
        else {
            
            guard let url = URL(string: "http://meditation.itsastudio.co/privacy-policy/") else { return  }
            let req = URLRequest(url: url)
            webview.loadRequest(req)
        }


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        
    }
    
    @IBAction func backToSettingsAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        
        backButton.setImage(ThemeSettings.sharedInstance.arrowImageLeft, for: .normal)
        backButton.setTitleColor(ThemeSettings.sharedInstance.themeButtonColor, for: .normal)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font:UIFont(name: "Apercu-Light", size: 15)]

        self.detailLabel.attributedText = NSAttributedString(string: detail, attributes:attributes as [NSAttributedString.Key : Any])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PrivacyViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let content = webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
        if (content?.count ?? 0) > 1 {
            AppStateStore.shared.privacyPolicy = content
        }
        hud.dismiss()
        print(content ?? "")
    }
    
}
