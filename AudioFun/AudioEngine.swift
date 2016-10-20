//
//  AudioEngine.swift
//  AudioFun
//
//  Created by Maciej Eichler on 20/10/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioEngineDelegate {
    func audioEngineReturned(_ engine: AudioEngine, samples: [Float])
}

class AudioEngine {
    private var engine: AVAudioEngine
    private var sampleRate: Double
    
    var bufferSize: AVAudioFrameCount
    var delegate: AudioEngineDelegate?
    var isRunning: Bool {
        get {
            return engine.isRunning
        }
    }
    
    init(sampleRate: Double, bufferSize: AVAudioFrameCount) {
        engine = AVAudioEngine()
        self.sampleRate = sampleRate
        self.bufferSize = bufferSize
    }
    
    // MARK: - Engine Methods
    func setupAudioEngine() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            let ioBufferDuration = 64.0 / sampleRate
            
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
            
            self.delegate?.audioEngineReturned(self, samples: Array<Float>(samples))
        }
    }
    
    func startEngine() {
        if !engine.isRunning {
            do {
                try engine.start()
                //print("AVAudioEngine started!")
            } catch {
                print("AVAudioEngine start error: \(error)")
            }
        }
    }
    
    func stopEngine() {
        if engine.isRunning {
            engine.stop()
            //print("AVAudioEngine stopped!")
        }
    }
}
