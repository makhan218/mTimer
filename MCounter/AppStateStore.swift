//
//  AppStateStore.swift
//  MCounter
//
//  Created by Muhammad Ahmad on 18/04/2019.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import Foundation

enum DefaultsVariables: String {
    case resetTimer = "resettingTimer"
    case soundOn    = "soundOn"
    case vibrationOn = "vibrationOn"
    case warmupIntervel = "warmupIntervel"
    case autoDayNight = "autoDayNight"
    case sunset     =   "sunsetTime"
    case sunrise    = "sunriseTime"
    case selectedSound = "SelectedSound"
    case selectedWarmupSound = "selectedWarmupSound"
    case selectedMode  = "SelectedMode"
    case Membership    = "Membership"
    case memberHeading = "memberHeading"
    case memberFeatures = "memberFeatures"
    case developHeading = "developHeading"
    case developFeatures = "developFeatures"
    case usHeading       = "usHeading"
    case usFeatures      = "usFeatures"
    case proUser       = "paid pro user"
    case privacyPolicy = "privacy policy"
    case streatLastDate = "streat date"
    case streakDays     = "number of streak days"
    case warmupTimer    = "WarmupTimerOn"
    case themeNumber    = "theme Number"
    
}

class AppStateStore {
    
    static let shared: AppStateStore = AppStateStore()
    
    var resetTimer:Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.resetTimer.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: DefaultsVariables.resetTimer.rawValue)
        }
    }
    
    var soundOn:Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.soundOn.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: DefaultsVariables.soundOn.rawValue)
        }
    }
    
    var vibrationOn:Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.vibrationOn.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: DefaultsVariables.vibrationOn.rawValue)
        }
    }
    
    var isProUser:Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.proUser.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: DefaultsVariables.proUser.rawValue)
        }
    }
    
    var isWarmupTimerOn:Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.warmupTimer.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: DefaultsVariables.warmupTimer.rawValue)
        }
    }
    
    var warmupTimerIntervel:Int {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.warmupIntervel.rawValue)
        }
        get {
            return UserDefaults.standard.integer(forKey: DefaultsVariables.warmupIntervel.rawValue)
        }
    }
    
    var privacyPolicy:String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.privacyPolicy.rawValue)
        }
        get {
            return UserDefaults.standard.string(forKey: DefaultsVariables.privacyPolicy.rawValue)
        }
    }
    
    
    
    var membershipSaved:Membership {
        set(newValue) {
            
            
            UserDefaults.standard.set(newValue.developFeatures, forKey: DefaultsVariables.developFeatures.rawValue)
            UserDefaults.standard.set(newValue.developHeading, forKey: DefaultsVariables.developHeading.rawValue)
            
            UserDefaults.standard.set(newValue.memberFeatures, forKey: DefaultsVariables.memberFeatures.rawValue)
            UserDefaults.standard.set(newValue.memberHeading, forKey: DefaultsVariables.memberHeading.rawValue)
            UserDefaults.standard.set(newValue.usFeatures, forKey: DefaultsVariables.usFeatures.rawValue)
            UserDefaults.standard.set(newValue.usHeading, forKey: DefaultsVariables.usHeading.rawValue)
               
        }
        get {
            
            var member = Membership()
            member.usHeading = UserDefaults.standard.string(forKey: DefaultsVariables.usHeading.rawValue)
            member.usFeatures = UserDefaults.standard.array(forKey: DefaultsVariables.usFeatures.rawValue) as? [String]
            member.memberHeading = UserDefaults.standard.string(forKey: DefaultsVariables.memberHeading.rawValue)
            
            member.memberFeatures = UserDefaults.standard.array(forKey: DefaultsVariables.memberFeatures.rawValue) as? [String]
            member.developHeading = UserDefaults.standard.string(forKey: DefaultsVariables.developHeading.rawValue)
            member.developFeatures = UserDefaults.standard.array(forKey: DefaultsVariables.developFeatures.rawValue) as? [String]
            
            return member
       
        }
    }
    
    var selectedWarmupSound:soundType {
           set(newValue) {
               UserDefaults.standard.set(newValue.rawValue, forKey: DefaultsVariables.selectedWarmupSound.rawValue)
           }
           get {
               return soundType(rawValue: UserDefaults.standard.string(forKey: DefaultsVariables.selectedWarmupSound.rawValue) ?? soundType.tibetanCrystal.rawValue) ?? soundType.tibetanCrystal
           }
       }
    
    var selectedSound:soundType {
        set(newValue) {
            UserDefaults.standard.set(newValue.rawValue, forKey: DefaultsVariables.selectedSound.rawValue)
        }
        get {
            return soundType(rawValue: UserDefaults.standard.string(forKey: DefaultsVariables.selectedSound.rawValue) ?? soundType.tibetanCrystal.rawValue) ?? soundType.tibetanCrystal
        }
    }
    
    
    var selectedMode:ThemeModes {
        set(newValue) {
            UserDefaults.standard.set(newValue.rawValue, forKey: DefaultsVariables.selectedMode.rawValue)
        }
        get {
            return ThemeModes(rawValue: UserDefaults.standard.string(forKey: DefaultsVariables.selectedMode.rawValue) ?? ThemeModes.alwaysWhite.rawValue) ?? ThemeModes.alwaysWhite
        }
    }
    
    var sunrise:Date {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.sunrise.rawValue)
        }
        get {
            return UserDefaults.standard.object(forKey: DefaultsVariables.sunrise.rawValue) as! Date? ?? Date()
        }
    }
    
    var streakLastDate:Date? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.streatLastDate.rawValue)
        }
        get {
            return UserDefaults.standard.object(forKey: DefaultsVariables.streatLastDate.rawValue) as? Date
        }
    }
    
    var ThemeNumber:Int {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.themeNumber.rawValue)
        }
        get {
            return UserDefaults.standard.integer(forKey: DefaultsVariables.themeNumber.rawValue)
        }
    }
    
    var streakDays:Int {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.streakDays.rawValue)
        }
        get {
            return UserDefaults.standard.integer(forKey: DefaultsVariables.streakDays.rawValue)
        }
    }
    
    var sunset:Date {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.sunset.rawValue)
        }
        get {
            return UserDefaults.standard.object(forKey: DefaultsVariables.sunset.rawValue) as! Date? ?? Date()
        }
    }
    
    
    var autoDayNightOn:Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: DefaultsVariables.autoDayNight.rawValue)
        }
        get {
            return UserDefaults.standard.bool(forKey: DefaultsVariables.autoDayNight.rawValue)
        }
    }
    
    func warmupSoundName()-> String {
        
        switch self.selectedWarmupSound {
        case .tibetanCrystal:
            return "TibetanCrystal"
        case .tibetanCrystalBowl:
            return "Tibetan-Crystal–Singing–Bowl"
        case .tibetanSingingBowl:
            return "Tibetan-Crystal-Singing-Bowl-2"
        case .singingBirds:
            return "Single-Bird-Chirps"
        }
    }
    
    func soundName()-> String {
        
        switch self.selectedSound {
        case .tibetanCrystal:
            return "TibetanCrystal"
        case .tibetanCrystalBowl:
            return "Tibetan-Crystal–Singing–Bowl"
        case .tibetanSingingBowl:
            return "Tibetan-Crystal-Singing-Bowl-2"
        case .singingBirds:
            return "Single-Bird-Chirps"
        }
    }
    
}
