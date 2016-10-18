//
//  DecibelAxisView.swift
//  AudioFun
//
//  Created by Maciej Eichler on 15/10/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

@IBDesignable
class DecibelAxisView: UIView {
    
    private let textRightMargin: CGFloat = 10
    private let textBottomMargin: CGFloat = 7.5
    private let fontSize: CGFloat = 15
    
    override func draw(_ rect: CGRect) {
        layer.sublayers = nil
        
        backgroundColor?.set()
        UIBezierPath(rect: rect).fill()
        
        let scaleLine = UIBezierPath()
        
        tintColor.withAlphaComponent(0.5).set()
        
        for num in 0...10 {
            scaleLine.move(to: CGPoint(x: rect.width, y: rect.height*CGFloat(num)/10))
            scaleLine.addLine(to: CGPoint(x: rect.width-5, y: rect.height*CGFloat(num)/10))
        }
        scaleLine.stroke()
        
        // ------ Axis Labels layers
        let label0rect = CGRect(origin: CGPoint(x: -textRightMargin, y: -textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "0", inRect: label0rect, colored: tintColor))
        
        let label10rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height*1/10 - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-10", inRect: label10rect, colored: tintColor))
        
        let label20rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height*2/10 - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-20", inRect: label20rect, colored: tintColor))
        
        let label30rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height*3/10 - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-30", inRect: label30rect, colored: tintColor))
        
        let label40rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height*4/10 - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-40", inRect: label40rect, colored: tintColor))
        
        let label50rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height*5/10 - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-50", inRect: label50rect, colored: tintColor))
        
        let label60rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height*6/10 - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-60", inRect: label60rect, colored: tintColor))
        
        let label70rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height*7/10 - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-70", inRect: label70rect, colored: tintColor))
        
        let label80rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height*8/10 - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-80", inRect: label80rect, colored: tintColor))
        
        let label90rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height*9/10 - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-90", inRect: label90rect, colored: tintColor))
        
        let label100rect = CGRect(origin: CGPoint(x: -textRightMargin, y: rect.height - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-100", inRect: label100rect, colored: tintColor))
    }
    
    private func getLabelLayer(withText txt: String, inRect rect: CGRect, colored color: UIColor) -> CALayer {
        let txtLayer = CATextLayer()
        txtLayer.contentsScale = UIScreen.main.scale
        txtLayer.foregroundColor = color.cgColor
        txtLayer.fontSize = fontSize
        txtLayer.alignmentMode = kCAAlignmentRight
        txtLayer.string = txt
        txtLayer.frame = rect
        
        return txtLayer
    }
}
