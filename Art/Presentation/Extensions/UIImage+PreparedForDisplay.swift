//
//  UIImage+preparedForDisplay.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import UIKit

extension UIImage {
    /// Prepares the image for efficient display by an image view. Reduces any synchronous processing required for
    /// rendering in an image view. This particularly helps in table/collection views where large amounts of data can be
    /// present on screen at once and high speed scroll view interactions occur
    var preparedForDisplay: UIImage? {
        get async {
            guard #available(iOS 15.0, *) else {
                return nil
            }

            return await byPreparingForDisplay()
        }
    }
}
