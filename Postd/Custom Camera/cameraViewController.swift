//
//  cameraViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/19/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class cameraViewController: UIViewController {
    
    // Variables
    
    let storageRef = Storage.storage().reference()
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    // Outlets
    
    @IBOutlet var videoModeButton: UIBarButtonItem!
    @IBOutlet var cameraSwitchButton: UIBarButtonItem!
    @IBOutlet var flashButton: UIBarButtonItem!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var captureButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentCamera?.automaticallyEnablesLowLightBoostWhenAvailable = true
        currentCamera?.focusMode = .autoFocus
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        
        // Zoom In recognizer
        zoomInGestureRecognizer.direction = .right
        zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGestureRecognizer)
        
        // Zoom Out recognizer
        zoomOutGestureRecognizer.direction = .left
        zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGestureRecognizer)
    }
    
    // Functions
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = view.frame
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }

    @objc func zoomIn() {
        if let zoomFactor = currentCamera?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func zoomOut() {
        if let zoomFactor = currentCamera?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveContent" {
            let saveVC = segue.destination as! saveViewController
            saveVC.image = self.image
        }
    }
    
    //Actions
    
    @IBAction func profileBtn(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "profileView")
        self.present(controller!, animated: false, completion: nil)
    }
    
    @IBAction func unwindToCapture(segue:UIStoryboardSegue) {
    }
    
    @IBAction func captureVideo(_ sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "captureView")
        self.present(controller!, animated: false, completion: nil)
    }
    
    @IBAction func flipCameraTapped(_ sender: UIBarButtonItem) {
        captureSession.beginConfiguration()
        
        // Change the device based on the current camera
        let newDevice = (currentCamera?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera
        
        // Remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to the new input
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentCamera = newDevice
        captureSession.commitConfiguration()
    }
    
    @IBAction func flashButtonTapped(_ sender: UIBarButtonItem) {
        if currentCamera!.hasFlash{
            do{
                try currentCamera!.lockForConfiguration()
                currentCamera!.flashMode = (currentCamera?.isFlashActive)! ? AVCaptureDevice.FlashMode.off : AVCaptureDevice.FlashMode.on
                
                currentCamera!.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
}

extension cameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData =  photo.fileDataRepresentation() {
            print(imageData)
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "saveContent", sender: nil)
        }
    }
}

