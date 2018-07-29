//
//  ViewController.swift
//  CustomCamera
//
//  Created by punyawee  on 29/7/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    
    @IBOutlet weak var captureBtn: UIButton! {
        didSet {
            captureBtn.layer.cornerRadius = captureBtn.frame.height / 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == .back {
                backCamera = device
            }
            else if device.position == .front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        if let currentCamera = currentCamera {
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
                captureSession.addInput(captureDeviceInput)
                photoOutput = AVCapturePhotoOutput()
                photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
                captureSession.addOutput(photoOutput!)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        if let cameraPreviewLayer = cameraPreviewLayer {
            cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            cameraPreviewLayer.frame = view.frame
            view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        }
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    @IBAction func capture(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPreview" {
            if let nav = segue.destination as? UINavigationController, let destination = nav.viewControllers.first as? PreviewViewController {
                destination.getImage = image
            }
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "ToPreview", sender: self)
        }
    }
}
