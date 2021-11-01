//
//  ThemeSettings.swift
//  MCounter
//
//  Created by Muhammad Ahmad on 26/03/2019.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import Foundation
import UIKit

struct ThemeColor {
    
    var name:String
    
    var lightTop:UIColor
    var lightBottom:UIColor
    var lightDot:UIColor
    
    var darkTop:UIColor
    var darkBottom:UIColor
    var darkDot:UIColor
    var textColor:UIColor
}

class ThemeSettings  {
    static let sharedInstance = ThemeSettings()
    
    var pickerActionBarColor:UIColor!
    var backgroundColor:UIColor!
    var cellBackgroundColor: UIColor!
    var weeklyCellBackColor: UIColor!
    var fontColor: UIColor!
    var blueFontColor: UIColor!
    var historyLogFontColor: UIColor!
    var historyLogBackColor:UIColor!
    var blinkerColor: UIColor!
    
    var topViewOpacity: CGFloat
    var bottomBackgroungColor: UIColor!
    var switchOnColor: UIColor!
    var switchOffColor: UIColor!
    var backButtonColor: UIColor!
    var themeButtonColor: UIColor!
    var themeSwitchColor: UIColor!
    var inactiveButtonColor: UIColor!
    var seperatorColor:UIColor!
    
    var settingsHeaderCellBackgroung: UIColor!
    var settingsHeaderCellFontColor : UIColor!
    var settingsBackgroung: UIColor!
    var cancelButtonTintColor: UIColor!
    var srrowTintColor: UIColor!
    var fadedButtonTextColor:UIColor!
    var pickerActionBarSeprator: UIColor!
    var centerSeprator:UIColor!
    
    var font21: UIFont!
    var font15: UIFont!
    var font28: UIFont!
    var font17: UIFont!
    var font30: UIFont!
    var fontMono17: UIFont!
    var fontMono14: UIFont!

    var settingsHeaderCellFont: UIFont!
    
    var warmupColor:UIColor!
    var arrowImage:UIImage!
    var crossImage:UIImage!
    var arrowImageLeft:UIImage!
    var settingsButton:UIImage!
    var toLink: UIImage!
    var monthArrowRight: UIImage!
    var monthArrowLeft: UIImage!
    var darkTheme = false
    
    var mainTop:UIColor!
    var mainBottom:UIColor!
    var mainDot:UIColor!
    var mainText:UIColor!
    var feedbackPlaceholderColor:UIColor!
    var feedbackInputFieldColor:UIColor!
    
    var feedbackInputFieldBackgroundColor:UIColor!
    var selectedColor:ThemeColor
    
    var colorsArray:[ThemeColor] = []
    
    init() {
        
        colorsArray.append(ThemeColor(name: "Gray", lightTop: .defaultLightTop, lightBottom: .defaultLightBottom, lightDot: .defaultLightDot, darkTop: .defaultDarkTop, darkBottom: .defaultDarkBottom, darkDot: .defaultDarkDot, textColor: .defaultDarkDot))
        
        colorsArray.append(ThemeColor(name: "Blue", lightTop: .defaultLightBlueTop, lightBottom: .defaultLightBlueBottom, lightDot: .defaultLightBlueDot, darkTop: .defaultDarkBlueTop, darkBottom: .defaultDarkBlueBottom, darkDot: .defaultDarkBlueDot, textColor: .defaultDarkBlueDot))
        
        colorsArray.append(ThemeColor(name: "Blue Red", lightTop: .defaultLightBlueRedTop, lightBottom: .defaultLightBlueRedBottom, lightDot: .defaultLightBlueRedDot, darkTop: .defaultDarkBlueRedTop, darkBottom: .defaultDarkBlueRedBottom, darkDot: .defaultDarkBlueRedDot, textColor: .defaultDarkBlueRedDot))
        
        colorsArray.append(ThemeColor(name: "Green", lightTop: .defaultLightGreenTop, lightBottom: .defaultLightGreenBottom, lightDot: .defaultLightGreenDot, darkTop: .defaultDarkGreenTop, darkBottom: .defaultDarkGreenBottom, darkDot: .defaultDarkGreenDot, textColor: .defaultDarkGreenDot))
        
        
        colorsArray.append(ThemeColor(name: "Red", lightTop: .defaultLightRedTop, lightBottom: .defaultLightRedBottom, lightDot: .defaultLightRedDot, darkTop: .defaultDarkRedTop, darkBottom: .defaultDarkRedBottom, darkDot: .defaultDarkRedDot, textColor: .defaultDarkRedDot))
        
        
        colorsArray.append(ThemeColor(name: "Green Blue", lightTop: .defaultLightGreenBlueTop, lightBottom: .defaultLightGreenBlueBottom, lightDot: .defaultLightGreenBlueDot, darkTop: .defaultDarkGreenBlueTop, darkBottom: .defaultDarkGreenBlueBottom, darkDot: .defaultDarkGreenBlueDot, textColor: .defaultDarkGreenBlueDot))
        
        colorsArray.append(ThemeColor(name: "Red Green", lightTop: .defaultLightRedGreenTop, lightBottom: .defaultLightRedGreenBottom, lightDot: .defaultLightRedGreenDot, darkTop: .defaultDarkRedGreenTop, darkBottom: .defaultDarkRedGreenBottom, darkDot: .defaultDarkRedGreenDot, textColor: .defaultDarkRedGreenDot))
        
        colorsArray.append(ThemeColor(name: "Blue Green", lightTop: .defaultLightBlueGreenTop, lightBottom: .defaultLightBlueGreenBottom, lightDot: .defaultLightBlueGreenDot, darkTop: .defaultDarkBlueGreenTop, darkBottom: .defaultDarkBlueGreenBottom, darkDot: .defaultDarkBlueGreenDot, textColor: .defaultDarkBlueGreenDot))
        
        
        colorsArray.append(ThemeColor(name: "Green Red", lightTop: .defaultLightGreenRedTop, lightBottom: .defaultLightGreenRedBottom, lightDot: .defaultLightGreenRedDot, darkTop: .defaultDarkGreenRedTop, darkBottom: .defaultDarkGreenRedBottom, darkDot: .defaultDarkGreenRedDot, textColor: .defaultDarkGreenRedDot))
        
        
        colorsArray.append(ThemeColor(name: "Red Blue", lightTop: .defaultLightRedBlueTop, lightBottom: .defaultLightRedBlueBottom, lightDot: .defaultLightRedBlueDot, darkTop: .defaultDarkRedBlueTop, darkBottom: .defaultDarkRedBlueBottom, darkDot: .defaultDarkRedBlueDot, textColor: .defaultDarkRedBlueDot))
        
        
        let tempTheme = colorsArray[AppStateStore.shared.ThemeNumber]
        
        selectedColor = ThemeColor(name: tempTheme.name, lightTop: tempTheme.lightTop, lightBottom: tempTheme.lightBottom, lightDot: tempTheme.lightDot, darkTop: tempTheme.darkTop, darkBottom: tempTheme.darkBottom, darkDot: tempTheme.darkDot, textColor: tempTheme.darkDot)
        
        font21 = UIFont(name: "Apercu-Light", size: 21)
        font15 = UIFont(name: "Apercu-Light", size: 15)
        font28 = UIFont(name: "Apercu-Light", size: 28)
        font17 = UIFont(name: "Apercu-Light", size: 17)
        font30 = UIFont(name: "Apercu-Light", size: 30)
        fontMono17 = UIFont(name: "ApercuMonoPro-Light", size: 17)
        fontMono14 = UIFont(name: "ApercuMonoPro-Light", size: 14)
        
        settingsHeaderCellFont = UIFont(name: "Apercu-Light", size: 13)
        
        mainTop = selectedColor.lightTop
//            UIColor(red: 230/255, green: 238/255, blue: 242/255, alpha: 1)
            
//            UIColor(red: 235/255, green: 238/255, blue: 242/255, alpha: 1)
        mainBottom = selectedColor.lightBottom
//            UIColor(red: 172/255, green: 185/255, blue: 191/255, alpha: 1)
//            UIColor(red: 218/255, green: 223/255, blue: 230/255, alpha: 1)
        mainDot = selectedColor.lightDot
        mainText = selectedColor.lightDot
//            UIColor(red: 41/255, green: 79/255, blue: 82/255, alpha: 1)
//            UIColor(red: 82/255, green: 142/255, blue: 147/255, alpha: 1)
        
        feedbackInputFieldColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        feedbackPlaceholderColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
        feedbackInputFieldBackgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
        cellBackgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
        pickerActionBarColor = UIColor(red: 250/255, green: 250/255, blue: 248/255, alpha: 1)
        pickerActionBarSeprator = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        historyLogBackColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        fontColor = UIColor.black
        
        blueFontColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        blinkerColor = UIColor.black
        topViewOpacity = 0.7
        arrowImage = #imageLiteral(resourceName: "SArrowright").withRenderingMode(.alwaysTemplate)
        crossImage = #imageLiteral(resourceName: "closeButtonLight")
        arrowImageLeft = #imageLiteral(resourceName: "blackArrowLeft")
        settingsButton = #imageLiteral(resourceName: "buttonSettingsCircleDots")
        toLink = #imageLiteral(resourceName: "toNet").withRenderingMode(.alwaysTemplate)
        monthArrowRight = #imageLiteral(resourceName: "MonthArrow_Right_LightMode")
        monthArrowLeft = #imageLiteral(resourceName: "MonthArrow_Left_LightMode")

        centerSeprator = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 1)

        srrowTintColor = UIColor(red: 90/255, green: 90/255, blue: 97/255, alpha: 0.7)
//            UIColor(red: 90/255, green: 90/255, blue: 97/255, alpha: 0.7)
        
        weeklyCellBackColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        historyLogFontColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
        cancelButtonTintColor = UIColor(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.19)
        settingsBackgroung = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        settingsHeaderCellFontColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
        seperatorColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.29)
        settingsHeaderCellBackgroung = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        bottomBackgroungColor = UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
//            UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
//            UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
        switchOnColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        switchOffColor = UIColor(red: 0, green: 209/255, blue: 165/255, alpha: 1)
        backButtonColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        warmupColor = UIColor.black
        themeButtonColor = UIColor.black
        themeSwitchColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
        inactiveButtonColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        fadedButtonTextColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
    
//            UIColor(red: 6/255, green: 154/255, blue: 243/255, alpha: 1)
        
    }
    
    func updateTheme() {
        if darkTheme {
            setDarkTheme()
        }
        else {
            setLightTheme()
        }
    }
    
    func setDarkTheme() {
        
        
        mainTop = UIColor(red: 76/255, green: 89/255, blue: 89/255, alpha: 1)
//            UIColor(red: 80/255, green: 94/255, blue: 94/255, alpha: 1)
        mainBottom = UIColor(red: 33/255, green: 38/255, blue: 38/255, alpha: 1)
//            UIColor(red: 59/255, green: 69/255, blue: 69/255, alpha: 1)
        mainDot = UIColor(red: 107/255, green: 206/255, blue: 211/255, alpha: 1)
        
//            UIColor(red: 97/255, green: 224/255, blue: 233/255, alpha: 1)
        
        let tempTheme = colorsArray[AppStateStore.shared.ThemeNumber]
        
        inactiveButtonColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        selectedColor = ThemeColor(name: tempTheme.name, lightTop: tempTheme.lightTop, lightBottom: tempTheme.lightBottom, lightDot: tempTheme.lightDot, darkTop: tempTheme.darkTop, darkBottom: tempTheme.darkBottom, darkDot: tempTheme.darkDot, textColor: tempTheme.darkDot)
        
        mainTop = selectedColor.darkTop
        mainBottom = selectedColor.darkBottom
        mainDot = selectedColor.darkDot
        mainText = selectedColor.darkDot
        
        feedbackInputFieldColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        feedbackPlaceholderColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
        feedbackInputFieldBackgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
            
        historyLogBackColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        srrowTintColor = UIColor(red: 235/255, green: 235/255, blue: 245/255, alpha: 0.3)
        cancelButtonTintColor = UIColor.white
        backgroundColor = UIColor.black
        cellBackgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        settingsBackgroung = UIColor.black
        
        fontColor = UIColor.white
        blueFontColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        blinkerColor = UIColor.white
        warmupColor = UIColor.black
//        changed in plus
        arrowImage = #imageLiteral(resourceName: "SArrowright").withRenderingMode(.alwaysTemplate)
        topViewOpacity = 0.7
        weeklyCellBackColor = UIColor.black
        pickerActionBarColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        bottomBackgroungColor = UIColor(red: 9/255, green: 12/255, blue: 13/255, alpha: 1)
//            UIColor.black
//            UIColor(red: 9/255, green: 12/255, blue: 13/255, alpha: 1)
        backButtonColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        seperatorColor = UIColor(red: 84/255, green: 84/255, blue: 88/255, alpha: 0.65)
        settingsHeaderCellFontColor = UIColor(red: 235/255, green: 235/255, blue: 245/255, alpha: 0.6)
        fadedButtonTextColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
        themeButtonColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        pickerActionBarSeprator = .black
        
        settingsHeaderCellBackgroung = .black
//            UIColor(red: 9/255, green: 12/255, blue: 13/255, alpha: 1)
        darkTheme = true
        arrowImage = #imageLiteral(resourceName: "SArrowright").withRenderingMode(.alwaysTemplate)
        crossImage = #imageLiteral(resourceName: "closeButtonDark")
        arrowImageLeft = #imageLiteral(resourceName: "arrowLeftWhite")
        settingsButton = #imageLiteral(resourceName: "Settings_Dark")
        toLink = #imageLiteral(resourceName: "toNet").withRenderingMode(.alwaysTemplate)
        monthArrowRight = #imageLiteral(resourceName: "MonthArrow_Right_DarkMode")
        monthArrowLeft = #imageLiteral(resourceName: "MonthArrow_Left_DarkMode")
        centerSeprator = .white
//            UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
//            UIColor(red: 21.0/255, green: 149.0/255, blue: 255.0/255, alpha: 1.0)
        //        (red: 21, green: 149, blue: 255, alpha: 1)
        
    }
    func setLightTheme() {
        
        topViewOpacity = 0.7
        
        mainTop = UIColor(red: 230/255, green: 238/255, blue: 242/255, alpha: 1)
        //            UIColor(red: 235/255, green: 238/255, blue: 242/255, alpha: 1)
                mainBottom = UIColor(red: 172/255, green: 185/255, blue: 191/255, alpha: 1)
        //            UIColor(red: 218/255, green: 223/255, blue: 230/255, alpha: 1)
                mainDot = UIColor(red: 41/255, green: 79/255, blue: 82/255, alpha: 1)
        //            UIColor(red: 82/255, green: 142/255, blue: 147/255, alpha: 1)
        
        let tempTheme = colorsArray[AppStateStore.shared.ThemeNumber]
        
        inactiveButtonColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        selectedColor = ThemeColor(name: tempTheme.name, lightTop: tempTheme.lightTop, lightBottom: tempTheme.lightBottom, lightDot: tempTheme.lightDot, darkTop: tempTheme.darkTop, darkBottom: tempTheme.darkBottom, darkDot: tempTheme.darkDot, textColor: tempTheme.darkDot)
        
        mainTop = selectedColor.lightTop
        mainBottom = selectedColor.lightBottom
        mainDot = selectedColor.lightDot
        mainText = selectedColor.lightDot

        feedbackInputFieldColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        feedbackPlaceholderColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
        feedbackInputFieldBackgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        centerSeprator = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 1)
        historyLogBackColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        pickerActionBarSeprator = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        pickerActionBarColor = UIColor(red: 250/255, green: 250/255, blue: 248/255, alpha: 1)
        srrowTintColor = UIColor(red: 90/255, green: 90/255, blue: 97/255, alpha: 0.7)
        cancelButtonTintColor = UIColor(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.19)
        backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
        cellBackgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
        settingsHeaderCellFontColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
//            UIColor.white
        settingsBackgroung = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        weeklyCellBackColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        fadedButtonTextColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
        
        fontColor = UIColor.black
        blueFontColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        blinkerColor = UIColor.black
        backButtonColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        settingsHeaderCellBackgroung = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        darkTheme = false
        seperatorColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.29)
        bottomBackgroungColor = UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
//            UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
//            UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
        warmupColor = UIColor.black
        arrowImage = #imageLiteral(resourceName: "blackArrowRight").withRenderingMode(.alwaysTemplate)
        crossImage = #imageLiteral(resourceName: "closeButtonLight")
        arrowImageLeft = #imageLiteral(resourceName: "blackArrowLeft")
        settingsButton = #imageLiteral(resourceName: "buttonSettingsCircleDots")
        toLink = #imageLiteral(resourceName: "toNet").withRenderingMode(.alwaysTemplate)
        monthArrowRight = #imageLiteral(resourceName: "MonthArrow_Right_LightMode")
        monthArrowLeft = #imageLiteral(resourceName: "MonthArrow_Left_LightMode")
        themeButtonColor = UIColor.black
//            UIColor(red: 255/255, green: 61/255, blue: 0/255, alpha: 1)
    }
        
    
}
