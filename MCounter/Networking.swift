//
//  Networking.swift
//  MCounter
//
//  Created by apple on 9/24/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import Foundation
import UIKit


struct Membership: Codable {
    var memberHeading: String?
    var memberFeatures: [String]?
    var developHeading: String?
    var developFeatures: [String]?
    var usHeading: String?
    var usFeatures: [String]?
    init() {
        memberHeading = ""
        memberFeatures = []
        developHeading = ""
        developFeatures = []
        usHeading = ""
        usFeatures = []
    }
}

let membershipUrl = "http://meditation.itsastudio.co/wp-json/member/membership_details"

class Networking {
    
    
    static func getMembership( actionOnTable : @escaping (() -> Void )   )  {
        
        guard let url = URL(string: membershipUrl ) else {return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    
                    let memberDecoder = JSONDecoder()
                    do {
                        let membership = try memberDecoder.decode(Membership.self, from: data)
                        print(membership)
                    } catch {
                        print(error.localizedDescription)
                    }
//                    do {
//                        membership = try memberDecoder.decode(Membership.self, from: data)
//                        actionOnTable()
//                    }
//                    catch {
//                        print("exception occur in decoding \(error.localizedDescription)")
//                    }
                }
            }
            
            
            }.resume()
    }
}
