//
//  ViewController.swift
//  AudioFun
//
//  Created by Maciej Eichler on 02/10/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit
import AVFoundation

class SpectrumViewController: UIViewController, AudioEngineDelegate, dBFreqAxesScalingDelegate {

    var engine: AudioEngine!
    var timer: Timer!
    var samples = [Float]()
    
    // Axes scaling delegate vars
    var sampleRate: Double = 44100.0
    var bufferSize: Double = 1024.0 {
        didSet {
            engine?.bufferSize = AVAudioFrameCount(bufferSize)
            bufferLabel?.text = "\(bufferSize)"
        }
    }
    
    @IBOutlet weak var spectrumView: SpectrumView! {
        didSet {
            spectrumView.delegate = self
        }
    }
    @IBOutlet weak var freqAxisView: FrequencyAxisView! {
        didSet {
            freqAxisView.delegate = self
        }
    }
    @IBOutlet weak var decibelAxisView: DecibelAxisView! {
        didSet {
            decibelAxisView.delegate = self
        }
    }
    @IBOutlet weak var bufferStepper: UIStepper!
    @IBOutlet weak var bufferLabel: UILabel!
    @IBOutlet weak var powerSwitch: UISwitch!
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine = AudioEngine(sampleRate: sampleRate, bufferSize: AVAudioFrameCount(bufferSize))
        engine.delegate = self
        engine.setupAudioEngine()
        
        // Timer loop setup
        timer = Timer(timeInterval: 0.01, target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
        
        // SpectrumView setup
        bufferLabel.text = "\(bufferSize)"
        
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if powerSwitch.isOn {
            engine.startEngine()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        engine.stopEngine()
    }
    
    // MARK: - AudioEngineDelegate
    
    func audioEngineReturned(_ engine: AudioEngine, samples: [Float]) {
        self.samples = samples
    }
    
    // MARK: UI Controls
    
    @IBAction func engineOnOff(_ sender: UISwitch) {
        if sender.isOn {
            engine.startEngine()
        } else {
            engine.stopEngine()
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if engine.isRunning {
            engine.stopEngine()
        }
        
        spectrumView.fft = nil

        bufferSize = pow(2.0, Double(sender.value))
        
        if powerSwitch.isOn {
            engine.startEngine()
        }
    }
    
    // MARK: Other methods
    
    func timerTick(sender: Timer?) {
        if engine.isRunning {
            if samples.count > 0 {
                spectrumView.fft = fft(samples)
            }
        }
    }
    
    func dBscaling(_ dB: CGFloat,_ height: CGFloat) -> CGFloat {
        let max: CGFloat = log2(128.0)
        let scaleFactor: CGFloat = height/max
        return log2(dB)*scaleFactor
    }
    
    func freqScaling(_ width: CGFloat,_ frequency: Double) -> CGFloat {
        let max = log10(((bufferSize/2)-1)*sampleRate/bufferSize) - 1
        let scaleFactor = Double(width)/max
        return CGFloat(log10(frequency/10)*scaleFactor)
    }
    
}

