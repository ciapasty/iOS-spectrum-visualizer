//
//  WaveformView.swift
//  AudioFun
//
//  Created by Maciej Eichler on 14/10/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

protocol dBFreqAxesScalingDelegate {
    var sampleRate: Double { get }
    var bufferSize: Double { get }
    func dBscaling(_ dB: CGFloat,_ height: CGFloat) -> CGFloat
    func freqScaling(_ width: CGFloat,_ frequency: Double) -> CGFloat
}

//@IBDesignable
class SpectrumView: UIView {
    
    var delegate: dBFreqAxesScalingDelegate?
    
    var fft:[Float]? {
        didSet {
            if fft != nil {
                fft = Array<Float>(fft!.prefix(fft!.count/2))
                //print("min:", fft!.min()!, "max:",fft!.max()!)
                //print(fft!)
            }
            setNeedsDisplay()
        }
    }
    
    private let scaleFrequencies: [Double] = [10,20,30,40,50,60,70,80,90,100,200,300,400,500,600,700,800,900,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000,20000]
    private let decibelLabels: [CGFloat] = [3.0, 6.0, 12.0, 24.0, 48.0, 96.0]
    
    override func draw(_ rect: CGRect) {
        backgroundColor?.set()
        UIBezierPath(rect: rect).fill()

        drawFreqScaleLines(inRect: rect)
        drawDecibelScaleLines(inRect: rect)
        
        if fft != nil {
            if fft!.count > 0 {
                drawSpectrum(inRect: rect)
            }
        }
    }

    private func drawSpectrum(inRect rect: CGRect) {
        let wave = UIBezierPath()
        //let divisor = CGFloat(fft!.count)/rect.width
        
        tintColor.set()
        
        wave.move(to: CGPoint(x: 0, y: rect.height))
        for (index, magn) in fft!.enumerated() {
            if index == 0 {
                continue
            }
            let freq = Double(index)*delegate!.sampleRate/delegate!.bufferSize
            if freq > 20000 {
                break
            } else {
                wave.addLine(to: CGPoint(x: delegate!.freqScaling(rect.width, freq),
                                         y: delegate!.dBscaling(CGFloat(abs(magn)), rect.height)))
            }
        }
        wave.stroke()
    }
    
    private func drawFreqScaleLines(inRect rect: CGRect) {
        let scaleLine = UIBezierPath()
        
        tintColor.withAlphaComponent(0.5).set()
        
        for freq in scaleFrequencies {
            let width = delegate!.freqScaling(rect.width, freq)
            scaleLine.move(to: CGPoint(x: width, y: 0))
            scaleLine.addLine(to: CGPoint(x: width, y: rect.height))
        }
        
        scaleLine.stroke()
    }
    
    private func drawDecibelScaleLines(inRect rect: CGRect) {
        let width = delegate!.freqScaling(rect.width, 20000)
        let scaleLine = UIBezierPath()
        
        tintColor.withAlphaComponent(0.5).set()
        
        scaleLine.move(to: CGPoint(x: 0, y: 0))
        scaleLine.addLine(to: CGPoint(x: width, y: 0))
        
        for dB in decibelLabels {
            let height = delegate!.dBscaling(dB, rect.height) //CGFloat(log2(dB)*heightScaling)
            scaleLine.move(to: CGPoint(x: 0, y: height))
            scaleLine.addLine(to: CGPoint(x: width, y: height))
        }
        
        scaleLine.move(to: CGPoint(x: 0, y: rect.height))
        scaleLine.addLine(to: CGPoint(x: width, y: rect.height))
        
        scaleLine.stroke()
    }
}
