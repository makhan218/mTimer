//
//  Extensions.swift
//  MCounter
//
//  Created by apple on 5/16/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    
    enum ViewSide {
        case Top, Bottom, Left, Right
    }

    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color.cgColor

        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: thickness)
        case .Bottom:
            border.frame = CGRect(x: 0, y: frame.size.height - thickness, width: frame.size.width, height: thickness)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.size.height)
        case .Right:
            border.frame = CGRect(x: frame.size.width - thickness, y: 0, width: thickness, height: frame.size.height)
        }

        layer.addSublayer(border)
    }
}


extension UIColor {
    
    static let defaultLightTop = UIColor(red: 230/255, green: 238/255, blue: 242/255, alpha: 1)
    static let defaultLightBottom = UIColor(red: 172/255, green: 185/255, blue: 191/255, alpha: 1)
    static let defaultLightDot = UIColor(red: 41/255, green: 79/255, blue: 82/255, alpha: 1)
    
    static let defaultDarkTop = UIColor(red: 76/255, green: 89/255, blue: 89/255, alpha: 1)
    static let defaultDarkBottom = UIColor(red: 33/255, green: 38/255, blue: 38/255, alpha: 1)
    static let defaultDarkDot = UIColor(red: 107/255, green: 206/255, blue: 211/255, alpha: 1)
    
    
    static let defaultLightBlueTop = UIColor(red: 179/255, green: 251/255, blue: 255/255, alpha: 1)
    static let defaultLightBlueBottom = UIColor(red: 82/255, green: 198/255, blue: 204/255, alpha: 1)
    static let defaultLightBlueDot = UIColor(red: 39/255, green: 74/255, blue: 77/255, alpha: 1)
    
    static let defaultDarkBlueTop = UIColor(red: 48/255, green: 104/255, blue: 107/255, alpha: 1)
    static let defaultDarkBlueBottom = UIColor(red: 39/255, green: 74/255, blue: 77/255, alpha: 1)
    static let defaultDarkBlueDot = UIColor(red: 82/255, green: 198/255, blue: 204/255, alpha: 1)
    
    
    static let defaultLightBlueRedTop = UIColor(red: 179/255, green: 251/255, blue: 255/255, alpha: 1)
    static let defaultLightBlueRedBottom = UIColor(red: 191/255, green: 77/255, blue: 96/255, alpha: 1)
    static let defaultLightBlueRedDot = UIColor(red: 39/255, green: 74/255, blue: 77/255, alpha: 1)
    
    static let defaultDarkBlueRedTop = UIColor(red: 48/255, green: 104/255, blue: 107/255, alpha: 1)
    static let defaultDarkBlueRedBottom = UIColor(red: 77/255, green: 38/255, blue: 45/255, alpha: 1)
    static let defaultDarkBlueRedDot = UIColor(red: 82/255, green: 198/255, blue: 204/255, alpha: 1)
    
    
    
    
    
    static let defaultLightGreenTop = UIColor(red: 244/255, green: 247/255, blue: 173/255, alpha: 1)
    static let defaultLightGreenBottom = UIColor(red: 185/255, green: 191/255, blue: 76/255, alpha: 1)
    static let defaultLightGreenDot = UIColor(red: 75/255, green: 77/255, blue: 39/255, alpha: 1)
    
    static let defaultDarkGreenTop = UIColor(red: 104/255, green: 107/255, blue: 48/255, alpha: 1)
    static let defaultDarkGreenBottom = UIColor(red: 75/255, green: 77/255, blue: 39/255, alpha: 1)
    static let defaultDarkGreenDot = UIColor(red: 185/255, green: 191/255, blue: 76/255, alpha: 1)
    
    
    static let defaultLightRedTop = UIColor(red: 255/255, green: 179/255, blue: 191/255, alpha: 1)
    static let defaultLightRedBottom = UIColor(red: 191/255, green: 77/255, blue: 96/255, alpha: 1)
    static let defaultLightRedDot = UIColor(red: 77/255, green: 38/255, blue: 45/255, alpha: 1)
    
    static let defaultDarkRedTop = UIColor(red: 107/255, green: 48/255, blue: 58/255, alpha: 1)
    static let defaultDarkRedBottom = UIColor(red: 77/255, green: 38/255, blue: 45/255, alpha: 1)
    static let defaultDarkRedDot = UIColor(red: 191/255, green: 77/255, blue: 96/255, alpha: 1)
    
    
    static let defaultLightGreenBlueTop = UIColor(red: 244/255, green: 247/255, blue: 173/255, alpha: 1)
    static let defaultLightGreenBlueBottom = UIColor(red: 82/255, green: 198/255, blue: 204/255, alpha: 1)
    static let defaultLightGreenBlueDot = UIColor(red: 75/255, green: 78/255, blue: 39/255, alpha: 1)
    
    static let defaultDarkGreenBlueTop = UIColor(red: 104/255, green: 107/255, blue: 48/255, alpha: 1)
    static let defaultDarkGreenBlueBottom = UIColor(red: 39/255, green: 74/255, blue: 77/255, alpha: 1)
    static let defaultDarkGreenBlueDot = UIColor(red: 185/255, green: 191/255, blue: 77/255, alpha: 1)
    
    
    static let defaultLightRedGreenTop = UIColor(red: 255/255, green: 179/255, blue: 191/255, alpha: 1)
    static let defaultLightRedGreenBottom = UIColor(red: 185/255, green: 191/255, blue: 77/255, alpha: 1)
    static let defaultLightRedGreenDot = UIColor(red: 77/255, green: 38/255, blue: 45/255, alpha: 1)
    
    static let defaultDarkRedGreenTop = UIColor(red: 107/255, green: 48/255, blue: 58/255, alpha: 1)
    static let defaultDarkRedGreenBottom = UIColor(red: 75/255, green: 78/255, blue: 39/255, alpha: 1)
    static let defaultDarkRedGreenDot = UIColor(red: 191/255, green: 77/255, blue: 96/255, alpha: 1)
    
    
    static let defaultLightBlueGreenTop = UIColor(red: 179/255, green: 251/255, blue: 255/255, alpha: 1)
    static let defaultLightBlueGreenBottom = UIColor(red: 185/255, green: 191/255, blue: 77/255, alpha: 1)
    static let defaultLightBlueGreenDot = UIColor(red: 39/255, green: 74/255, blue: 77/255, alpha: 1)
    
    static let defaultDarkBlueGreenTop = UIColor(red: 48/255, green: 104/255, blue: 107/255, alpha: 1)
    static let defaultDarkBlueGreenBottom = UIColor(red: 75/255, green: 78/255, blue: 39/255, alpha: 1)
    static let defaultDarkBlueGreenDot = UIColor(red: 82/255, green: 198/255, blue: 204/255, alpha: 1)

    
    static let defaultLightGreenRedTop = UIColor(red: 244/255, green: 247/255, blue: 173/255, alpha: 1)
    static let defaultLightGreenRedBottom = UIColor(red: 191/255, green: 77/255, blue: 96/255, alpha: 1)
    static let defaultLightGreenRedDot = UIColor(red: 75/255, green: 78/255, blue: 39/255, alpha: 1)
    
    static let defaultDarkGreenRedTop = UIColor(red: 104/255, green: 107/255, blue: 48/255, alpha: 1)
    static let defaultDarkGreenRedBottom = UIColor(red: 77/255, green: 38/255, blue: 45/255, alpha: 1)
    static let defaultDarkGreenRedDot = UIColor(red: 185/255, green: 191/255, blue: 77/255, alpha: 1)
    
    
    static let defaultLightRedBlueTop = UIColor(red: 255/255, green: 179/255, blue: 191/255, alpha: 1)
    static let defaultLightRedBlueBottom = UIColor(red: 82/255, green: 198/255, blue: 204/255, alpha: 1)
    static let defaultLightRedBlueDot = UIColor(red: 77/255, green: 38/255, blue: 45/255, alpha: 1)
    
    static let defaultDarkRedBlueTop = UIColor(red: 107/255, green: 48/255, blue: 58/255, alpha: 1)
    static let defaultDarkRedBlueBottom = UIColor(red: 39/255, green: 74/255, blue: 77/255, alpha: 1)
    static let defaultDarkRedBlueDot = UIColor(red: 191/255, green: 77/255, blue: 96/255, alpha: 1)
    
    
}



extension CALayer {
    func addGradientBorder(colors:[UIColor],width:CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.0)
        gradientLayer.endPoint = CGPoint(x:1.0,y:1.0)
        gradientLayer.colors = colors.map({$0.cgColor})

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.red.cgColor
        gradientLayer.mask = shapeLayer

        self.addSublayer(gradientLayer)
    }
}


extension UserDefaults {
 func colorForKey(key: String) -> UIColor? {
  var color: UIColor?
  if let colorData = data(forKey: key) {
   color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
  }
  return color
 }

 func setColor(color: UIColor?, forKey key: String) {
  var colorData: NSData?
   if let color = color {
    colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
  }
  set(colorData, forKey: key)
 }

}
