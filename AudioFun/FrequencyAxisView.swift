//
//  FrequencyAxisView.swift
//  AudioFun
//
//  Created by Maciej Eichler on 15/10/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

//@IBDesignable
class FrequencyAxisView: UIView {
    
    var delegate: dBFreqAxesScalingDelegate?
    
    private let fontSize: CGFloat = 15
    
    override func draw(_ rect: CGRect) {
        layer.sublayers = nil
        
        backgroundColor?.set()
        UIBezierPath(rect: rect).fill()
        
        let markedFreq: [Double] = [10,100,1000,10000]
        let scaleLine = UIBezierPath()
        
        tintColor.withAlphaComponent(0.5).set()
        
        for freq in markedFreq {
            scaleLine.move(to: CGPoint(x: delegate!.freqScaling(rect.width, freq), y: rect.origin.y))
            scaleLine.addLine(to: CGPoint(x: delegate!.freqScaling(rect.width, freq), y: rect.origin.y + 5))
        }
        scaleLine.stroke()
        
        // ------ Axis Labels layers
        let label10rect = CGRect(origin: CGPoint(x: -5, y: rect.origin.y + 5), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "10", inRect: label10rect, colored: tintColor))
        
        let label100rect = CGRect(origin: CGPoint(x: delegate!.freqScaling(rect.width, 100) - 5, y: rect.origin.y + 5), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "100", inRect: label100rect, colored: tintColor) )
        
        let label1krect = CGRect(origin: CGPoint(x: delegate!.freqScaling(rect.width, 1000) - 5, y: rect.origin.y + 5), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "1k", inRect: label1krect, colored: tintColor))
        
        let label10krect = CGRect(origin: CGPoint(x: delegate!.freqScaling(rect.width, 10000) - 5, y: rect.origin.y + 5), size: rect.size)
        layer.addSublayer(getLabelLayer(withText: "10k", inRect: label10krect, colored: tintColor))
    }
    
    private func getLabelLayer(withText txt: String, inRect rect: CGRect, colored color: UIColor) -> CALayer {
        let txtLayer = CATextLayer()
        txtLayer.contentsScale = UIScreen.main.scale
        txtLayer.foregroundColor = color.cgColor
        txtLayer.fontSize = fontSize
        txtLayer.string = txt
        txtLayer.frame = rect
        
        return txtLayer
    }
}
