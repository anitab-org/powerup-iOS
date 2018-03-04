//
//  SegueHandler.swift
//  Powerup
//
//  Created by SIMRANPREET KAUR on 04/03/18.
//  Copyright © 2018 Systers. All rights reserved.
//

import Foundation
import UIKit
extension SegueHandler where Self: UIViewController, ViewControllerSegue.RawValue == String {
    
    func segueIdentifierCase(for segue: UIStoryboardSegue) -> ViewControllerSegue {
        guard let identifier = segue.identifier,
            let identifierCase = ViewControllerSegue(rawValue: identifier) else {
                fatalError("Could not map segue identifier -- \(segue.identifier) -- to segue case")
        }
        return identifierCase
    }
    
}
