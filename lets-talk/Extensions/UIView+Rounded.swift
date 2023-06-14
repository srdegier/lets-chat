//
//  UIView+Rounded.swift
//  lets-talk
//
//  Created by Stefan de Gier on 14/06/2023.
//

import Foundation
import UIKit

extension UIView {
    func updateMaskedCorners(roundedCorners: UIRectCorner, cornerRadii: CGSize) {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: roundedCorners,
                                    cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        self.layoutIfNeeded()
    }
}
