//
//  WaveformView.swift
//  AudioFun
//
//  Created by Maciej Eichler on 14/10/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

@IBDesignable
class SpectrumView: UIView {
    
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
    
    var samplingRate: Double = 44100.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var bufferSize: Double = 512.0 {
        didSet {
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
        let max = log10(((bufferSize/2)-1)*samplingRate/bufferSize) - 1
        let scaleFactor = Double(rect.width)/max
        let heightScaling = rect.height/(log2(128.0))
        let wave = UIBezierPath()
        //let divisor = CGFloat(fft!.count)/rect.width
        
        tintColor.set()
        
        wave.move(to: CGPoint(x: 0, y: rect.height))
        for (index, magn) in fft!.enumerated() {
            if index == 0 {
                continue
            }
            let freq = Double(index)*samplingRate/bufferSize
            if freq > 20000 {
                break
            } else {
                let freqLog = log10(freq/10)
                wave.addLine(to: CGPoint(x: CGFloat(freqLog*scaleFactor), y: CGFloat(log2(abs(magn)))*heightScaling))
            }
        }
        wave.stroke()
    }
    
    private func drawFreqScaleLines(inRect rect: CGRect) {
        let max = log10(((bufferSize/2)-1)*samplingRate/bufferSize) - 1
        let scaleFactor = Double(rect.width)/max
        let scaleLine = UIBezierPath()
        
        tintColor.withAlphaComponent(0.5).set()
        
        for freq in scaleFrequencies {
            scaleLine.move(to: CGPoint(x: CGFloat(log10(freq/10)*scaleFactor), y: 0))
            scaleLine.addLine(to: CGPoint(x: CGFloat(log10(freq/10)*scaleFactor), y: rect.height))
        }
        
        scaleLine.stroke()
    }
    
    private func drawDecibelScaleLines(inRect rect: CGRect) {
        let max = log10(((bufferSize/2)-1)*samplingRate/bufferSize) - 1
        let scaleFactor = Double(rect.width)/max
        let heightScaling = rect.height/(log2(128.0))
        
        let scaleLine = UIBezierPath()
        
        tintColor.withAlphaComponent(0.5).set()
        
        scaleLine.move(to: CGPoint(x: 0, y: 0))
        scaleLine.addLine(to: CGPoint(x: CGFloat(log10(2000)*scaleFactor), y: 0))
        
        for dB in decibelLabels {
            let height = CGFloat(log2(dB)*heightScaling)
            scaleLine.move(to: CGPoint(x: 0, y: height))
            scaleLine.addLine(to: CGPoint(x: CGFloat(log10(2000)*scaleFactor), y: height))
        }
        
        scaleLine.move(to: CGPoint(x: 0, y: rect.height))
        scaleLine.addLine(to: CGPoint(x: CGFloat(log10(2000)*scaleFactor), y: rect.height))
        
        scaleLine.stroke()
    }
}
