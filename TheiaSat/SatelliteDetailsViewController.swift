//
//  SatelliteDetailsViewController.swift
//  TheiaSat
//
//  Created by Michael VanDyke on 6/7/19.
//  Copyright © 2019 Michael VanDyke. All rights reserved.
//

import UIKit

class SatelliteDetailsViewController: UIViewController {
    var currentSatellite: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sat = currentSatellite {
            title = "\(sat) Details"
        }
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
