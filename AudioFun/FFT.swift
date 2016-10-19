// FFT.swift
//
// Created by: Mattt Thompson (http://mattt.me)
//
// Modified by: Mattijah. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Accelerate

// MARK: Fast Fourier Transform

public func fft(_ input: [Float]) -> [Float] {
    var buffer = [Float](input)
    var real = [Float](repeating: 0.0, count: input.count)
    var imaginary = [Float](repeating: 0.0, count: input.count)
    
    var hannWindow = [Float](repeating: 0.0, count: input.count)
    vDSP_hann_window(&hannWindow, vDSP_Length(input.count), 0)
    vDSP_vmul(&buffer, 1, hannWindow, 1, &real, 1, vDSP_Length(input.count))
    
    var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(input.count))))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetup(length, radix)
    vDSP_fft_zip(weights!, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
    
    var magnitudes = [Float](repeating: 0.0, count: input.count)
    vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
    
    var normalizedMagnitudes = [Float](repeating: 0.0, count: input.count)
    vDSP_vsmul(magnitudes.map({ (sample) -> Float in
        return sqrt(sample)
    }), 1, [4.0 / Float(input.count)], &normalizedMagnitudes, 1, vDSP_Length(input.count))
    
    var logNormMagnitudes = [Float](repeating: 0.0, count: input.count)
    var mul: Float = 10.0
    vDSP_vsmul(normalizedMagnitudes.map({ (sample) -> Float in
        return log10(sample)
    }), 1, &mul, &logNormMagnitudes, 1, vDSP_Length(input.count))
    
    vDSP_destroy_fftsetup(weights)
    
    return logNormMagnitudes //normalizedMagnitudes
}

public func fft(_ input: [Double]) -> [Double] {
    var buffer = [Double](input)
    var real = [Double](repeating: 0.0, count: input.count)
    var imaginary = [Double](repeating: 0.0, count: input.count)
    
    var hannWindow = [Double](repeating: 0.0, count: input.count)
    vDSP_hann_windowD(&hannWindow, vDSP_Length(input.count), 0)
    vDSP_vmulD(&buffer, 1, hannWindow, 1, &real, 1, vDSP_Length(input.count))
    
    var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)
    
    let length = vDSP_Length(floor(log2(Float(input.count))))
    let radix = FFTRadix(kFFTRadix2)
    let weights = vDSP_create_fftsetupD(length, radix)
    vDSP_fft_zipD(weights!, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
    
    var magnitudes = [Double](repeating: 0.0, count: input.count)
    vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
    
    var normalizedMagnitudes = [Double](repeating: 0.0, count: input.count)
    vDSP_vsmulD(magnitudes.map({ (sample) -> Double in
        return sqrt(sample)
    }), 1, [4.0 / Double(input.count)], &normalizedMagnitudes, 1, vDSP_Length(input.count))
    
    var logNormMagnitudes = [Double](repeating: 0.0, count: input.count)
    var mul: Double = 10.0
    vDSP_vsmulD(normalizedMagnitudes.map({ (sample) -> Double in
        return log10(sample)
    }), 1, &mul, &logNormMagnitudes, 1, vDSP_Length(input.count))
    
    vDSP_destroy_fftsetupD(weights)
    
    return logNormMagnitudes //normalizedMagnitudes
}

