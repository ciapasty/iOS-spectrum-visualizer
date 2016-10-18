//
//  ViewController.swift
//  AudioFun
//
//  Created by Maciej Eichler on 02/10/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit
import AVFoundation

class SpectrumViewController: UIViewController {

    var engine = AVAudioEngine()
    
    var timer: Timer!
    var sampleRate: Double = 44100.0
    var bufferSize: AVAudioFrameCount = 512 {
        didSet {
            spectrumView?.bufferSize = Double(bufferSize)
            freqAxisView?.bufferSize = Double(bufferSize)
            bufferLabel?.text = "\(bufferSize)"
        }
    }
    var samples = [Float]()
    
    @IBOutlet weak var spectrumView: SpectrumView!
    @IBOutlet weak var freqAxisView: FrequencyAxisView!
    @IBOutlet weak var bufferStepper: UIStepper!
    @IBOutlet weak var bufferLabel: UILabel!
    @IBOutlet weak var powerSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudioEngine()
        
        // Timer loop setup
        timer = Timer(timeInterval: 0.01, target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
        
        // SpectrumView setup
        spectrumView.samplingRate = sampleRate
        spectrumView.bufferSize = Double(bufferSize)
        freqAxisView.bufferSize = Double(bufferSize)
        bufferLabel.text = "\(bufferSize)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if powerSwitch.isOn {
            startEngine()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopEngine()
    }
    
    @IBAction func engineOnOff(_ sender: UISwitch) {
        if sender.isOn {
            startEngine()
        } else {
            stopEngine()
        }
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if engine.isRunning {
            stopEngine()
        }
        
        spectrumView.fft = nil
        switch sender.value {
        case 1:
            bufferSize = 64
        case 2:
            bufferSize = 128
        case 3:
            bufferSize = 256
        case 4:
            bufferSize = 512
        case 5:
            bufferSize = 1024
        case 6:
            bufferSize = 2048
        case 7:
            bufferSize = 4096
        default:
            break
        }
        if powerSwitch.isOn {
            startEngine()
        }
    }
    
    func timerTick(sender: Timer?) {
        if engine.isRunning {
            if samples.count > 0 {
                spectrumView.fft = fft(samples) //.map({ (sample) -> Float in
//                    20*log10(sample)
//                })
            }
        }
    }
    
    func setupAudioEngine() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            let ioBufferDuration = Double(bufferSize) / sampleRate
            
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(ioBufferDuration)
        } catch {
            print("AVAudioSession setup error: \(error)")
        }
        
        let mixer = engine.mainMixerNode
        let input = engine.inputNode!
        
        sampleRate = input.inputFormat(forBus: 0).sampleRate
        
        engine.connect(input, to: mixer, format: input.inputFormat(forBus: 0))
        
        input.installTap(onBus: 0, bufferSize: bufferSize, format: input.inputFormat(forBus: 0)) { (buffer, time) in
            buffer.frameLength = self.bufferSize
            let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(buffer.format.channelCount))
            let samples = UnsafeBufferPointer(start: channels[0], count: Int(buffer.frameLength))
            
            self.samples = Array<Float>(samples)
        }
    }
		
	func startEngine() {
        if !engine.isRunning {
            do {
                try engine.start()
                //print("AVAudioEngine started!")
                
                RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
                
            } catch {
                print("AVAudioEngine start error: \(error)")
            }
        }
    }
    
    func stopEngine() {
        if engine.isRunning {
            engine.stop()
            //print("AVAudioEngine stopped!")
            
            RunLoop.current.cancelPerform(#selector(self.timerTick), target: self, argument: nil)
        }
    }
}

