//
//  ViewController.swift
//  QR Code Scanner
//
//  Created by Min Hwang on 2016. 11. 8..
//  Copyright © 2016년 Min Hwang. All rights reserved.
//

// https://developer.apple.com/library/prerelease/content/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/04_MediaCapture.html#//apple_ref/doc/uid/TP40010188-CH5-SW2

// https://developer.apple.com/reference/avfoundation/avcapturemetadataoutput


import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var videoPreview: UIView!
    
    enum MyError: Error {
        case noCameraAvailable
        case videoInputInitiationFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            try scanQRCode()
        } catch {
            print("Failed to scan QR code!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        print("captured")
    }

    func scanQRCode() throws {
        let avCaptureSession = AVCaptureSession()
        
        // the returned device is always of the builtInWideAngleCamera device type
        guard let avCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            print("No camera available.")
            throw MyError.noCameraAvailable
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Failed to initiate AVCaptureDeviceInput for video.")
            throw MyError.videoInputInitiationFail
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        // This must be done after being added to the Capture Session, otherwise an exception will be raised.
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer?.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer!)
        
        avCaptureSession.startRunning()
    }
}

