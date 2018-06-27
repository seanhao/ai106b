//
//  ViewController.swift
//  Eye
//
//  Created by Sean on 23/06/2018.
//  Copyright © 2018 seanhao. All rights reserved.
//

import UIKit
// audiovisual media use to capture from camera
import AVFoundation
// framework for CoreML or face dection...
import Vision


class ViewController: UIViewController , AVCaptureVideoDataOutputSampleBufferDelegate {
    // AVCaptureVideoDataOutputSampleBufferDelegate is a methods for receiving sample buffers from and monitoring the status of a video data output.
    
    // create a label to hold the xxxxxx name and confidence
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "偵測中..."
        label.font = label.font.withSize(30)
        return label
    }()
    let label2: UILabel = {
        let label2 = UILabel()
        label2.textColor = .white
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.text = "偵測中..."
        label2.font = label2.font.withSize(30)
        return label2
    }()
    var camerap = "a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // call the parent function
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    
        
        // establish the capture session and add the label
        setupCaptureSession(cam:camerap)
        view.addSubview(label)
        view.addSubview(label2)
        setupLabel()
        BackButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupCaptureSession(cam:String) {
        
        // create a new capture session
        let captureSession = AVCaptureSession()
        
        // select back or front cam
        var campos = AVCaptureDevice.Position.back
        
        if cam == "a" {
            campos = AVCaptureDevice.Position.back
            camerap = "a"
        }
        else if cam == "b" {
            campos = AVCaptureDevice.Position.front
            camerap = "b"
        }
        
        // find the available cameras
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: campos).devices
        
        do {
            // select a camera
            if let captureDevice = availableDevices.first {
                captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
            }
        } catch {
            // print an error if the camera is not available
            print(error.localizedDescription)
        }
        
        // setup the video output to the screen and add output to our capture session
        let captureOutput = AVCaptureVideoDataOutput()
        captureSession.addOutput(captureOutput)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        // buffer the video and start the capture session
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.startRunning()
    }
    //辨識區
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // load our CoreML model
        
        guard let model = try? VNCoreMLModel(for: Emotions().model) else { return }
        
        // run an inference with CoreML
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            
            // grab the inference results
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            
            // grab the highest confidence result
            let Observation = results[0]
            let Observation2 = results[1]
            // create the label text components
            let predclass = "\(Observation.identifier)"
            let predconfidence = String(format: "%.02f%", Observation.confidence * 100)
            let predclass2 = "\(Observation2.identifier)"
            let predconfidence2 = String(format: "%.02f%", Observation2.confidence * 100)
            
            // set the label text
            DispatchQueue.main.async(execute: {
                self.label.text = "\(predclass) \(predconfidence) ％"
                self.label2.text = "\(predclass2) \(predconfidence2) ％"
            })
        }
        
        // create a Core Video pixel buffer which is an image buffer that holds pixels in main memory
        // Applications generating frames, compressing or decompressing video, or using Core Image
        // can all make use of Core Video pixel buffers
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // execute the request
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func setupLabel() {
        // constrain the label in the center
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // constrain the the label to 50 pixels from the bottom
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        label2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // constrain the the label to 50 pixels from the bottom
        label2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            print("Swipe Right")
            changeCamera()
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            print("Swipe Left")
            changeCamera()
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
            print("Swipe Up")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            print("Swipe Down")
        }
    }
    
        func changeCamera(){
            if camerap == "a"{
                setupCaptureSession(cam: "b")
                view.addSubview(label)
                view.addSubview(label2)
                BackButton()
            }
            else {
                setupCaptureSession(cam: "a")
                view.addSubview(label)
                view.addSubview(label2)
                BackButton()
            }
        }

    func BackButton(){
        
        let fullSize = UIScreen.main.bounds.size
        let myButton = UIButton(frame: CGRect(
            x: 0, y: 0, width: 100, height: 30))
        myButton.layer.borderWidth = 1.5
        myButton.layer.cornerRadius = 16
        myButton.layer.masksToBounds = true
        myButton.setTitle("<返回", for: UIControlState.normal)
        myButton.backgroundColor = UIColor.clear
        myButton.setBackgroundColor(color: UIColor.black, forState: UIControlState.highlighted)
        
        myButton.setTitleColor(UIColor.black, for: .normal)
        myButton.setTitleColor(UIColor.white, for: .highlighted)
        myButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        myButton.addTarget(
            nil, action: #selector(GoMenu),
            for: .touchUpInside)
        myButton.center = CGPoint(
            x: fullSize.width * 0.17, y: fullSize.height * 0.07)
        self.view.addSubview(myButton)
    }
    @objc func GoMenu() {
        self.present(StartViewController(), animated: true, completion: nil)
    }

}

