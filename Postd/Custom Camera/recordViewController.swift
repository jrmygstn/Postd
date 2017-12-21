//
//  recordViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 12/7/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit

class recordViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    // Variables
    
    public var audioEnabled = true
    public var shouldUseDeviceOrientation = true
    
    let storageRef = Storage.storage().reference().child("storyPhotos")
    
    let captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var videoFileOutput:AVCaptureMovieFileOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var isRecording = false
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    // Outlets
    
    @IBOutlet var photoModeButton: UIBarButtonItem!
    @IBOutlet var cameraSwitchButton: UIBarButtonItem!
    @IBOutlet var flashButton: UIBarButtonItem!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var recordIcon: CustomizableImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEnabled = true
        shouldUseDeviceOrientation = true
        
        currentCamera?.automaticallyAdjustsVideoHDREnabled = true
        currentCamera?.automaticallyEnablesLowLightBoostWhenAvailable = true
        currentCamera?.focusMode = .autoFocus
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        // Zoom In recognizer
        zoomInGestureRecognizer.direction = .right
        zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGestureRecognizer)
        
        // Zoom Out recognizer
        zoomOutGestureRecognizer.direction = .left
        zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGestureRecognizer)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
    }
    
    // Functions
    
    func askMicroPhonePermission(completion: @escaping (_ success: Bool)-> Void) {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            completion(true)
        case AVAudioSessionRecordPermission.denied:
            completion(false) //show alert if required
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    completion(true)
                } else {
                    completion(false) // show alert if required
                }
            })
        default:
            completion(false)
        }
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
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
            videoFileOutput = AVCaptureMovieFileOutput()
            captureSession.addOutput(videoFileOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
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
        if segue.identifier == "playVideo" {
            let videoPlayerViewController = segue.destination as! AVPlayerViewController
            let videoFileURL = sender as! URL
            videoPlayerViewController.player = AVPlayer(url: videoFileURL)
        }
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate methods
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error != nil {
            print(error)
            return
        }
        
        performSegue(withIdentifier: "playVideo", sender: outputFileURL)
    }
    
    //Actions
    
    @IBAction func profileBtn(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "profileView")
        self.present(controller!, animated: false, completion: nil)
    }
    
    @IBAction func unwindToRecord(segue:UIStoryboardSegue) {
    }
    
    @IBAction func capturePhoto(_ sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "photoView")
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
        if currentCamera!.hasTorch{
            do{
                try currentCamera!.lockForConfiguration()
                currentCamera!.torchMode = (currentCamera?.isTorchActive)! ? AVCaptureDevice.TorchMode.off : AVCaptureDevice.TorchMode.on
                
                currentCamera!.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if !isRecording {
            isRecording = true
            
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = URL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecording(to: outputFileURL, recordingDelegate: self)
            recordButton.isSelected = true
        } else {
            isRecording = false
            
            recordButton.isSelected = false
            recordButton.layer.removeAllAnimations()
            videoFileOutput?.stopRecording()
        }
    }
    
//    func saveChanges(){
//
//        let imageName = NSUUID().uuidString
//
//        let storedImage = storageRef.child("storyVideos").child(imageName)
//
//        if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
//            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                if error != nil{
//                    print(error!)
//                    return
//                }
//                storedImage.downloadURL(completion: { (url, error) in
//                    if error != nil{
//                        print(error!)
//                        return
//                    }
//                })
//            })
//        }
//    }
    
}
