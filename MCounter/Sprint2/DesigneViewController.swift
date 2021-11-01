//
//  DesigneViewController.swift
//  MCounter
//
//  Created by Muhammad Ahmad on 30/03/2019.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class DesigneViewController: UIViewController {
    @IBOutlet weak var circularTimer: CircleTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        circularTimer.startTimer(duration: 60)
        
    }

}
