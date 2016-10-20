//
//  DecibelAxisView.swift
//  AudioFun
//
//  Created by Maciej Eichler on 15/10/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

//@IBDesignable
class DecibelAxisView: UIView {
    
    var delegate: dBFreqAxesScalingDelegate?
    
    private let textRightMargin: CGFloat = 10
    private let textBottomMargin: CGFloat = 7.5
    private let fontSize: CGFloat = 15
    private let decibelLabels: [CGFloat] = [3.0, 6.0, 12.0, 24.0, 48.0, 96.0]
    
    override func draw(_ rect: CGRect) {
        layer.sublayers = nil
        
        backgroundColor?.set()
        UIBezierPath(rect: rect).fill()
        
        let scaleLine = UIBezierPath()
        
        tintColor.withAlphaComponent(0.5).set()
        
        scaleLine.move(to: CGPoint(x: rect.width, y: 0))
        scaleLine.addLine(to: CGPoint(x: rect.width-5, y: 0))
        
        for dB in decibelLabels {
            let height = delegate!.dBscaling(dB, rect.height)
            scaleLine.move(to: CGPoint(x: rect.width, y: height))
            scaleLine.addLine(to: CGPoint(x: rect.width-5, y: height))
        }
        
        scaleLine.move(to: CGPoint(x: rect.width, y: rect.height))
        scaleLine.addLine(to: CGPoint(x: rect.width-5, y: rect.height))
        
        scaleLine.stroke()
        
        // ------ Axis Labels layers
        let label0rect = CGRect(origin: CGPoint(x: -textRightMargin, y: -textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "0", inRect: label0rect, colored: tintColor))
        
        for dB in decibelLabels {
            let labelRect = CGRect(origin: CGPoint(x: -textRightMargin, y: delegate!.dBscaling(dB, rect.height) - textBottomMargin), size: rect.size)
            layer.addSublayer(getLabelLayer(withText: "-\(Int(dB))", inRect: labelRect, colored: tintColor))
        }
        
        let label70rect = CGRect(origin: CGPoint(x: -textRightMargin, y: delegate!.dBscaling(128, rect.height) - textBottomMargin), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "-inf", inRect: label70rect, colored: tintColor))
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
