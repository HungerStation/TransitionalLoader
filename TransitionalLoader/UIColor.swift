//
//  UIColor.swift
//  TransitionalLoader
//
//  Created by Ammar Altahhan on 18/08/2019.
//  Copyright © 2019 Ammar Altahhan. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(cgColor: CGColor?) {
        if let cgColor = cgColor {
            self.init(cgColor: cgColor)
        } else {
            return nil
        }
    }
}
