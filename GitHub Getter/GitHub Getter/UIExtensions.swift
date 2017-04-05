//
//  UIExtensions.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/4/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

extension UIResponder {
    static var identifier : String {
        return String(describing: self)
    }
}
