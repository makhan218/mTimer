//
//  FeedBackViewController.swift
//  MCounter
//
//  Created by apple on 5/9/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit
import Toast_Swift

class FeedBackViewController: UIViewController {
    @IBOutlet weak var feedBackLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var inputSepratorView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var labelSepratorView: UIView!
    
    @IBOutlet weak var headerSepratorView: UIView!
    @IBOutlet weak var labelSepratorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerSepratorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputSepratorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var permissionDetailLabel: UILabel!
    @IBOutlet weak var permissionTitle: UILabel!
    @IBOutlet weak var feedbackSwitch: UISwitch!
    static func instance() -> FeedBackViewController {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let FeedBackViewController = storyboard.instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
        return FeedBackViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupView()
        
    }
    @IBAction func backButton(_ sender: Any) {
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)

        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func feedbackButtonAction(_ sender: Any) {
        
        if !Reachability.isConnectedToNetwork() {
            var style = ToastStyle()
            style.messageColor = ThemeSettings.sharedInstance.feedbackInputFieldColor
            style.backgroundColor = ThemeSettings.sharedInstance.inactiveButtonColor

            self.view.makeToast("Internet not available", duration: 3.0, position: .bottom, style: style)
            return 
        }
        
        if emailField.text == "" {
            emailField.layer.borderWidth = 1
            emailField.layer.cornerRadius = 8
            emailField.layer.borderColor = UIColor.red.cgColor
            return
        }
        else if textArea.text == "" {
            emailField.layer.borderWidth = 1
            emailField.layer.cornerRadius = 8
            emailField.layer.borderColor = UIColor.red.cgColor
            return
        }
        else if !ValidateEmailString(strEmail: emailField?.text ?? "" ) {
            emailField.layer.borderWidth = 1
            emailField.layer.cornerRadius = 8
            emailField.layer.borderColor = UIColor.red.cgColor
            return
        }
        if Reachability.isConnectedToNetwork() {
            emailSending()
        }
  
        
//        sendEmail()
//        let subject = "Some subject"
//        let body = "Plenty of email body."
//        let coded = "mailto:blah@blah.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//
//        if let emailURL: NSURL = NSURL(string: coded!) {
//            if UIApplication.shared.canOpenURL(emailURL as URL) {
//                UIApplication.shared.openURL(emailURL as URL)
//            }
//        }
        
    }
//    func sendEmail() {
////        let mailComposeView = MFMailComposeViewController()
//        mailComposeView.mailComposeDelegate = self
//        // Configure the fields of the interface.
//        mailComposeView.setToRecipients(["address@example.com"])
//        mailComposeView.setSubject("Hello!")
//        mailComposeView.setMessageBody("Hello this is my message body!", isHTML: false)
//        // Present the view controller modally.
//        self.present(mailComposeView, animated: true, completion: nil)
//    }
//
//    func mailComposeController(controller: MFMailComposeViewController,
//                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//        // Check the result or perform other tasks.
//        // Dismiss the mail compose view controller.
//        controller.dismiss(animated: true, completion: nil)
//    }
    
}

extension FeedBackViewController {
    
    func ValidateEmailString (strEmail:String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailText = NSPredicate(format:"SELF MATCHES [c]%@",emailRegex)
        return (emailText.evaluate(with: strEmail))
    }
    
    func setupView() {
        
        self.view.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        feedBackLabel.textColor = ThemeSettings.sharedInstance.fontColor
        
        permissionTitle.textColor = ThemeSettings.sharedInstance.fontColor
        permissionDetailLabel.textColor = ThemeSettings.sharedInstance.fontColor
        buttonOutlet.layer.cornerRadius = 8
        
        backButton.setTitleColor(ThemeSettings.sharedInstance.backButtonColor, for: .normal)
        backButton.setImage(ThemeSettings.sharedInstance.arrowImageLeft, for: .normal)
        backButton.tintColor = ThemeSettings.sharedInstance.backButtonColor
        backButton.imageView?.alpha = 0.5
        
        
        inputSepratorView.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        labelSepratorView.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        headerSepratorView.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0){
            inputSepratorHeightConstraint.constant = 0.5
            labelSepratorHeightConstraint.constant = 0.5
            headerSepratorHeightConstraint.constant = 0.5
        }
        else {
            inputSepratorHeightConstraint.constant = 0.8
            labelSepratorHeightConstraint.constant = 0.8
            headerSepratorHeightConstraint.constant = 0.8
        }
        
        feedbackSwitch.tintColor = ThemeSettings.sharedInstance.themeSwitchColor
        feedbackSwitch.onTintColor = ThemeSettings.sharedInstance.themeSwitchColor
        feedbackSwitch.isOn = false
        buttonOutlet.isEnabled = false
        feedbackSwitch.addTarget(self, action: #selector(onSwitchValueChanged), for: .touchUpInside)
        
        emailField.textColor = ThemeSettings.sharedInstance.feedbackInputFieldColor
        emailField.returnKeyType = .done
        textArea.returnKeyType = .done
        emailField.delegate = self
        emailField.layer.cornerRadius = 8
        textArea.layer.cornerRadius  = 8
        textArea.delegate = self
        textArea.text = "Feedback"
        textArea.textColor = ThemeSettings.sharedInstance.feedbackPlaceholderColor
        textArea.backgroundColor = ThemeSettings.sharedInstance.feedbackInputFieldBackgroundColor
        headerView.backgroundColor = ThemeSettings.sharedInstance.cellBackgroundColor
        emailField.backgroundColor = ThemeSettings.sharedInstance.feedbackInputFieldBackgroundColor
//            UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        emailField.attributedPlaceholder = NSAttributedString(string: "Email address",attributes: [NSAttributedString.Key.backgroundColor: UIColor.clear,NSAttributedString.Key.foregroundColor: ThemeSettings.sharedInstance.feedbackPlaceholderColor])
        emailField.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor 
        buttonOutlet.titleLabel?.font = UIFont(name: "Apercu-Medium", size: 17)

        buttonOutlet.backgroundColor = ThemeSettings.sharedInstance.inactiveButtonColor

        
//        let shadowSize : CGFloat = 20.0
//        let shadowPath = UIBezierPath(rect: CGRect(x: textArea.bounds.origin.x + 10,
//                                                   y: textArea.bounds.origin.y + 10,
//                                                   width: self.textArea.frame.size.width + shadowSize,
//                                                   height: self.textArea.frame.size.height + shadowSize))
//        self.textArea.layer.masksToBounds = false
//        self.textArea.layer.shadowColor = UIColor.gray.cgColor
//        self.textArea.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.textArea.layer.shadowOpacity = 0.3
//        self.textArea.layer.shadowPath = shadowPath.cgPath
    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        switch (result) {
//        case .sent:
//            print("You sent the email.")
//            break
//        case .saved:
//            print("You saved a draft of this email")
//            break
//        case .cancelled:
//            print("You cancelled sending this email.")
//            break
//        case .failed:
//            print("Mail failed:  An error occurred when trying to compose this email")
//            break
//        default:
//            print("An error occurred when trying to compose this email")
//            break
//        }
//        // Dismiss the mail compose view controller.
//        controller.dismiss(animated: true, completion: nil)
//    }
    
    
    @objc func onSwitchValueChanged(_ uiSwitch: UISwitch) {
        
        if uiSwitch.isOn {
            buttonOutlet.backgroundColor = ThemeSettings.sharedInstance.themeSwitchColor
            buttonOutlet.isEnabled = true
        }
        else {
            buttonOutlet.backgroundColor = ThemeSettings.sharedInstance.inactiveButtonColor
            buttonOutlet.isEnabled = false
        }
    }
//
    func emailSending() {
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "itsasstudiosupp0rt@gmail.com"
        smtpSession.password = "ejguawlxjoewxnua"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if let data = data {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "Feedback", mailbox: "itsasstudiosupp0rt@gmail.com")]
        builder.header.from = MCOAddress(displayName: "Mtimer", mailbox: "itsasstudiosupp0rt@gmail.com")
        builder.header.replyTo = [MCOAddress(displayName: "User", mailbox: emailField.text ?? "Ahmad.khan.218@gmail.com")]
            
        builder.header.subject = "Feed Back"
        var body = "<br /> <br /> <br />" + "OS: " + UIDevice.current.systemVersion + "<br />"
        body.append("Build:" +  (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "") + "<br />")
        body.append("Version:" +  (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""))
        body.append("<br />" + "Device:" + UIDevice.modelName)
        body.append("<br />" + "User Email: " + (emailField.text ?? "email") )
        var message = textArea.text + "<br />" + body
        message =  message.replacingOccurrences(of: "\n", with: "<br />")
        builder.htmlBody = message
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(String(describing: error))")
            } else {
                NSLog("Successfully sent email!")
            }
        }
        self.dismiss(animated: true, completion: nil)
        
    }
}

//MARK:- UITextField Delegate

extension FeedBackViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            emailField.attributedPlaceholder = NSAttributedString(string: "Email address",attributes: [NSAttributedString.Key.backgroundColor: UIColor.clear,NSAttributedString.Key.foregroundColor: ThemeSettings.sharedInstance.feedbackPlaceholderColor])
        }
    }
}




//MARK:- UitextView Delegate
extension FeedBackViewController: UITextViewDelegate {
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Feedback" && textView.textColor == ThemeSettings.sharedInstance.feedbackPlaceholderColor)
        {
            textView.text = ""
            textView.textColor = ThemeSettings.sharedInstance.feedbackInputFieldColor
        }
        textView.becomeFirstResponder() //Optional
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Feedback"
            textView.textColor = ThemeSettings.sharedInstance.feedbackPlaceholderColor
        }
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
